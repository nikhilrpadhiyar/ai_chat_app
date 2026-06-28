import 'package:get/get.dart';
import '../../../../core/storage/storage_service.dart';
import '../../data/datasources/conversation_local_datasource.dart';
import '../../data/repositories/conversation_repository_impl.dart';
import '../../domain/usecases/create_conversation_usecase.dart';
import '../../domain/usecases/delete_conversation_usecase.dart';
import '../../domain/usecases/get_conversations_usecase.dart';
import 'conversation_controller.dart';
import '../../../chat/presentation/controllers/chat_controller.dart';
import '../../../chat/presentation/controllers/chat_binding.dart';

class ConversationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ConversationLocalDataSource(), fenix: true);
    Get.lazyPut(() => ConversationRepositoryImpl(
          Get.find<ConversationLocalDataSource>(),
        ), fenix: true);
    Get.lazyPut(() => GetConversationsUseCase(Get.find<ConversationRepositoryImpl>()));
    Get.lazyPut(() => CreateConversationUseCase(Get.find<ConversationRepositoryImpl>()));
    Get.lazyPut(() => DeleteConversationUseCase(Get.find<ConversationRepositoryImpl>()));
    Get.lazyPut(() => ConversationController(
          Get.find<GetConversationsUseCase>(),
          Get.find<CreateConversationUseCase>(),
          Get.find<DeleteConversationUseCase>(),
          Get.find<StorageService>(),
        ));

    // Also wire up chat dependencies so ChatController is findable
    ChatBinding().dependencies();
  }
}
