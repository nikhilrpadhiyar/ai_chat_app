import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/storage_service.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/usecases/create_conversation_usecase.dart';
import '../../domain/usecases/delete_conversation_usecase.dart';
import '../../domain/usecases/get_conversations_usecase.dart';
import '../../../chat/presentation/controllers/chat_controller.dart';

class ConversationController extends GetxController {
  final GetConversationsUseCase _getConversations;
  final CreateConversationUseCase _createConversation;
  final DeleteConversationUseCase _deleteConversation;
  final StorageService _storage;

  ConversationController(
    this._getConversations,
    this._createConversation,
    this._deleteConversation,
    this._storage,
  );

  final conversations = <ConversationEntity>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final _uuid = const Uuid();

  String get _model =>
      _storage.read<String>(AppConstants.selectedModelKey) ?? AppConstants.defaultModel;

  @override
  void onInit() {
    super.onInit();
    loadConversations();
  }

  Future<void> loadConversations() async {
    isLoading.value = true;
    final result = await _getConversations();
    result.fold(
      (f) => errorMessage.value = f.message,
      (list) => conversations.assignAll(list),
    );
    isLoading.value = false;
  }

  Future<ConversationEntity?> createNewConversation() async {
    final now = DateTime.now();
    final conversation = ConversationEntity(
      id: _uuid.v4(),
      title: 'New Chat',
      createdAt: now,
      updatedAt: now,
      model: _model,
    );

    final result = await _createConversation(conversation);
    return result.fold(
      (f) {
        errorMessage.value = f.message;
        return null;
      },
      (conv) {
        conversations.insert(0, conv);
        return conv;
      },
    );
  }

  Future<void> deleteConversation(String id) async {
    final result = await _deleteConversation(id);
    result.fold(
      (f) => errorMessage.value = f.message,
      (_) => conversations.removeWhere((c) => c.id == id),
    );
  }

  void updateAfterMessage({
    required String conversationId,
    required String lastMessage,
  }) {
    final idx = conversations.indexWhere((c) => c.id == conversationId);
    if (idx == -1) return;
    final updated = conversations[idx].copyWith(
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
      final title = lastMessage.length > 40
          ? '${lastMessage.substring(0, 40)}...'
          : lastMessage;
      conversations[idx] = updated.copyWith(title: title);
    }
  }

  Future<void> openConversation(ConversationEntity conversation) async {
    final chatController = Get.find<ChatController>();
    chatController.loadConversation(conversation.id);
    Get.toNamed('/chat', arguments: conversation);
  }
}
