import 'dart:async';

import 'package:ai_chat_app/core/constants/app_constants.dart';
import 'package:ai_chat_app/core/error/failures.dart';
import 'package:ai_chat_app/core/storage/storage_service.dart';
import 'package:ai_chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:ai_chat_app/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:ai_chat_app/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:ai_chat_app/features/conversation/presentation/controllers/conversation_controller.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  ChatController(this._sendMessage, this._getMessages, this._storage);
  final SendMessageUseCase _sendMessage;
  final GetMessagesUseCase _getMessages;
  final StorageService _storage;

  final RxList<MessageEntity> messages = <MessageEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isStreaming = false.obs;
  final RxBool isListening = false.obs;
  final RxString streamingContent = ''.obs;
  final RxnString errorMessage = RxnString();

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final Uuid _uuid = const Uuid();
  final SpeechToText _stt = SpeechToText();

  String? _conversationId;
  String get _model =>
      _storage.read<String>(AppConstants.selectedModelKey) ??
      AppConstants.defaultModel;
  String? get _systemPrompt =>
      _storage.read<String>(AppConstants.systemPromptKey);

  StreamSubscription<dynamic>? _streamSub;

  void loadConversation(String conversationId) {
    _conversationId = conversationId;
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    if (_conversationId == null) return;
    isLoading.value = true;
    final Either<Failure, List<MessageEntity>> result = await _getMessages(
      _conversationId!,
    );
    result.fold(
      (Failure f) => errorMessage.value = f.message,
      (List<MessageEntity> list) => messages.assignAll(list),
    );
    isLoading.value = false;
    _scrollToBottom();
  }

  Future<void> sendMessage([String? overrideText]) async {
    final String text = (overrideText ?? textController.text).trim();
    if (text.isEmpty || isStreaming.value) return;
    if (_conversationId == null) return;

    textController.clear();
    errorMessage.value = null;

    final MessageEntity userMsg = MessageEntity(
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
    final String assistantId = _uuid.v4();
    final MessageEntity assistantMsg = MessageEntity(
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

    final StringBuffer buffer = StringBuffer();

    _streamSub =
        _sendMessage(
          conversationId: _conversationId!,
          history: messages
              .where((MessageEntity m) => m.id != assistantId)
              .toList(),
          userMessage: text,
          model: _model,
          systemPrompt: _systemPrompt,
        ).listen(
          (Either<Failure, String> result) {
            result.fold(
              (Failure failure) {
                _finalizeStreaming(
                  assistantId,
                  buffer.toString(),
                  isError: true,
                );
                errorMessage.value = failure.message;
              },
              (String token) {
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
    final int idx = messages.indexWhere((MessageEntity m) => m.id == id);
    if (idx == -1) return;
    messages[idx] = messages[idx].copyWith(content: content);
    messages.refresh();
  }

  void _finalizeStreaming(String id, String content, {bool isError = false}) {
    isStreaming.value = false;
    streamingContent.value = '';
    _streamSub?.cancel();
    final int idx = messages.indexWhere((MessageEntity m) => m.id == id);
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
      final ConversationController conv = Get.find<ConversationController>();
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
    final bool available = await _stt.initialize(
      onError: (SpeechRecognitionError e) => isListening.value = false,
    );
    if (!available) {
      Get.snackbar(
        'Voice Unavailable',
        'Speech recognition is not available on this device',
      );
      return;
    }
    isListening.value = true;
    await _stt.listen(
      onResult: (SpeechRecognitionResult result) {
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
