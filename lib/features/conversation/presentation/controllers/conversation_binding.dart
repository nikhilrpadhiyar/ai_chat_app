import 'package:ai_chat_app/core/storage/storage_service.dart';
import 'package:ai_chat_app/features/chat/presentation/controllers/chat_binding.dart';
import 'package:ai_chat_app/features/conversation/data/datasources/conversation_local_datasource.dart';
import 'package:ai_chat_app/features/conversation/data/repositories/conversation_repository_impl.dart';
import 'package:ai_chat_app/features/conversation/domain/usecases/create_conversation_usecase.dart';
import 'package:ai_chat_app/features/conversation/domain/usecases/delete_conversation_usecase.dart';
import 'package:ai_chat_app/features/conversation/domain/usecases/get_conversations_usecase.dart';
import 'package:ai_chat_app/features/conversation/presentation/controllers/conversation_controller.dart';
import 'package:get/get.dart';

class ConversationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConversationLocalDataSource(), fenix: true);
    Get.lazyPut(
      () => ConversationRepositoryImpl(Get.find<ConversationLocalDataSource>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetConversationsUseCase(Get.find<ConversationRepositoryImpl>()),
    );
    Get.lazyPut(
      () => CreateConversationUseCase(Get.find<ConversationRepositoryImpl>()),
    );
    Get.lazyPut(
      () => DeleteConversationUseCase(Get.find<ConversationRepositoryImpl>()),
    );
    Get.lazyPut(
      () => ConversationController(
        Get.find<GetConversationsUseCase>(),
        Get.find<CreateConversationUseCase>(),
        Get.find<DeleteConversationUseCase>(),
        Get.find<StorageService>(),
      ),
    );

    // Also wire up chat dependencies so ChatController is findable
    ChatBinding().dependencies();
  }
}
