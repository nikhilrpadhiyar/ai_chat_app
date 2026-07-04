import 'package:ai_chat_app/core/constants/app_constants.dart';
import 'package:ai_chat_app/core/error/failures.dart';
import 'package:ai_chat_app/core/storage/storage_service.dart';
import 'package:ai_chat_app/features/chat/presentation/controllers/chat_controller.dart';
import 'package:ai_chat_app/features/conversation/domain/entities/conversation_entity.dart';
import 'package:ai_chat_app/features/conversation/domain/usecases/create_conversation_usecase.dart';
import 'package:ai_chat_app/features/conversation/domain/usecases/delete_conversation_usecase.dart';
import 'package:ai_chat_app/features/conversation/domain/usecases/get_conversations_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ConversationController extends GetxController {
  ConversationController(
    this._getConversations,
    this._createConversation,
    this._deleteConversation,
    this._storage,
  );
  final GetConversationsUseCase _getConversations;
  final CreateConversationUseCase _createConversation;
  final DeleteConversationUseCase _deleteConversation;
  final StorageService _storage;

  final RxList<ConversationEntity> conversations = <ConversationEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  final Uuid _uuid = const Uuid();

  String get _model =>
      _storage.read<String>(AppConstants.selectedModelKey) ??
      AppConstants.defaultModel;

  @override
  void onInit() {
    super.onInit();
    loadConversations();
  }

  Future<void> loadConversations() async {
    isLoading.value = true;
    final Either<Failure, List<ConversationEntity>> result =
        await _getConversations();
    result.fold(
      (Failure f) => errorMessage.value = f.message,
      (List<ConversationEntity> list) => conversations.assignAll(list),
    );
    isLoading.value = false;
  }

  Future<ConversationEntity?> createNewConversation() async {
    final DateTime now = DateTime.now();
    final ConversationEntity conversation = ConversationEntity(
      id: _uuid.v4(),
      title: 'New Chat',
      createdAt: now,
      updatedAt: now,
      model: _model,
    );

    final Either<Failure, ConversationEntity> result =
        await _createConversation(conversation);
    return result.fold(
      (Failure f) {
        errorMessage.value = f.message;
        return null;
      },
      (ConversationEntity conv) {
        conversations.insert(0, conv);
        return conv;
      },
    );
  }

  Future<void> deleteConversation(String id) async {
    final Either<Failure, void> result = await _deleteConversation(id);
    result.fold(
      (Failure f) => errorMessage.value = f.message,
      (_) => conversations.removeWhere((ConversationEntity c) => c.id == id),
    );
  }

  void updateAfterMessage({
    required String conversationId,
    required String lastMessage,
  }) {
    final int idx = conversations.indexWhere(
      (ConversationEntity c) => c.id == conversationId,
    );
    if (idx == -1) return;
    final ConversationEntity updated = conversations[idx].copyWith(
      lastMessage: lastMessage,
      updatedAt: DateTime.now(),
      messageCount: conversations[idx].messageCount + 1,
    );
    conversations[idx] = updated;
    // Move to top
    conversations.remove(updated);
    conversations.insert(0, updated);

    // Auto-generate title from first user message if still "New Chat"
    if (conversations[idx].title == 'New Chat' && lastMessage.isNotEmpty) {
      final String title = lastMessage.length > 40
          ? '${lastMessage.substring(0, 40)}...'
          : lastMessage;
      conversations[idx] = updated.copyWith(title: title);
    }
  }

  Future<void> openConversation(ConversationEntity conversation) async {
    final ChatController chatController = Get.find<ChatController>();
    chatController.loadConversation(conversation.id);
    Get.toNamed('/chat', arguments: conversation);
  }
}
