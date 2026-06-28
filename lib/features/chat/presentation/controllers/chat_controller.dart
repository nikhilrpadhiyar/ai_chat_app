import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/storage_service.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../../conversation/presentation/controllers/conversation_controller.dart';

class ChatController extends GetxController {
  final SendMessageUseCase _sendMessage;
  final GetMessagesUseCase _getMessages;
  final StorageService _storage;

  ChatController(this._sendMessage, this._getMessages, this._storage);

  final messages = <MessageEntity>[].obs;
  final isLoading = false.obs;
  final isStreaming = false.obs;
  final isListening = false.obs;
  final streamingContent = ''.obs;
  final errorMessage = RxnString();

  final textController = TextEditingController();
  final scrollController = ScrollController();
  final _uuid = const Uuid();
  final _stt = SpeechToText();

  String? _conversationId;
  String get _model =>
      _storage.read<String>(AppConstants.selectedModelKey) ?? AppConstants.defaultModel;
  String? get _systemPrompt => _storage.read<String>(AppConstants.systemPromptKey);

  StreamSubscription<dynamic>? _streamSub;

  void loadConversation(String conversationId) {
    _conversationId = conversationId;
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    if (_conversationId == null) return;
    isLoading.value = true;
    final result = await _getMessages(_conversationId!);
    result.fold(
      (f) => errorMessage.value = f.message,
      (list) => messages.assignAll(list),
    );
    isLoading.value = false;
    _scrollToBottom();
  }

  Future<void> sendMessage([String? overrideText]) async {
    final text = (overrideText ?? textController.text).trim();
    if (text.isEmpty || isStreaming.value) return;
    if (_conversationId == null) return;

    textController.clear();
    errorMessage.value = null;

    final userMsg = MessageEntity(
      id: _uuid.v4(),
      conversationId: _conversationId!,
      role: MessageRole.user,
      content: text,
      status: MessageStatus.sent,
      createdAt: DateTime.now(),
    );
    messages.add(userMsg);
    _scrollToBottom();

    // Placeholder assistant message for streaming
    final assistantId = _uuid.v4();
    final assistantMsg = MessageEntity(
      id: assistantId,
      conversationId: _conversationId!,
      role: MessageRole.assistant,
      content: '',
      status: MessageStatus.streaming,
      createdAt: DateTime.now(),
    );
    messages.add(assistantMsg);
    isStreaming.value = true;
    streamingContent.value = '';

    final buffer = StringBuffer();

    _streamSub = _sendMessage(
      conversationId: _conversationId!,
      history: messages.where((m) => m.id != assistantId).toList(),
      userMessage: text,
      model: _model,
      systemPrompt: _systemPrompt,
    ).listen(
      (result) {
        result.fold(
          (failure) {
            _finalizeStreaming(assistantId, buffer.toString(), isError: true);
            errorMessage.value = failure.message;
          },
          (token) {
            buffer.write(token);
            streamingContent.value = buffer.toString();
            _updateStreamingMessage(assistantId, buffer.toString());
            _scrollToBottom();
          },
        );
      },
      onDone: () {
        _finalizeStreaming(assistantId, buffer.toString());
        _updateConversationMeta(text, buffer.toString());
      },
      onError: (Object e) {
        _finalizeStreaming(assistantId, buffer.toString(), isError: true);
        errorMessage.value = e.toString();
      },
    );
  }

  void _updateStreamingMessage(String id, String content) {
    final idx = messages.indexWhere((m) => m.id == id);
    if (idx == -1) return;
    messages[idx] = messages[idx].copyWith(content: content);
    messages.refresh();
  }

  void _finalizeStreaming(String id, String content, {bool isError = false}) {
    isStreaming.value = false;
    streamingContent.value = '';
    _streamSub?.cancel();
    final idx = messages.indexWhere((m) => m.id == id);
    if (idx == -1) return;
    messages[idx] = messages[idx].copyWith(
      content: content.isEmpty ? '(No response)' : content,
      status: isError ? MessageStatus.error : MessageStatus.sent,
    );
    messages.refresh();
  }

  void _updateConversationMeta(String userText, String aiResponse) {
    if (_conversationId == null) return;
    try {
      final conv = Get.find<ConversationController>();
      conv.updateAfterMessage(
        conversationId: _conversationId!,
        lastMessage: aiResponse.isNotEmpty ? aiResponse : userText,
      );
    } catch (_) {}
  }

  void applyTemplate(String prompt) {
    textController.text = prompt;
    textController.selection = TextSelection.fromPosition(
      TextPosition(offset: prompt.length),
    );
  }

  Future<void> startVoiceInput() async {
    final available = await _stt.initialize(
      onError: (e) => isListening.value = false,
    );
    if (!available) {
      Get.snackbar('Voice Unavailable', 'Speech recognition is not available on this device');
      return;
    }
    isListening.value = true;
    await _stt.listen(
      onResult: (result) {
        if (result.finalResult) {
          textController.text = result.recognizedWords;
          isListening.value = false;
        }
      },
      listenFor: AppConstants.voiceListenTimeout,
      pauseFor: AppConstants.voicePauseTimeout,
    );
  }

  Future<void> stopVoiceInput() async {
    await _stt.stop();
    isListening.value = false;
  }

  void clearError() => errorMessage.value = null;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    _streamSub?.cancel();
    textController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
