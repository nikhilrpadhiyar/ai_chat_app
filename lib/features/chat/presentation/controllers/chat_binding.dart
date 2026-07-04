import 'package:ai_chat_app/core/network/api_client.dart';
import 'package:ai_chat_app/core/storage/storage_service.dart';
import 'package:ai_chat_app/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:ai_chat_app/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:ai_chat_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:ai_chat_app/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:ai_chat_app/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:ai_chat_app/features/chat/presentation/controllers/chat_controller.dart';
import 'package:get/get.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatRemoteDataSource(Get.find<ApiClient>()));
    Get.lazyPut(() => ChatLocalDataSource());
    Get.lazyPut(
      () => ChatRepositoryImpl(
        Get.find<ChatRemoteDataSource>(),
        Get.find<ChatLocalDataSource>(),
      ),
    );
    Get.lazyPut(() => SendMessageUseCase(Get.find<ChatRepositoryImpl>()));
    Get.lazyPut(() => GetMessagesUseCase(Get.find<ChatRepositoryImpl>()));
    Get.lazyPut(
      () => ChatController(
        Get.find<SendMessageUseCase>(),
        Get.find<GetMessagesUseCase>(),
        Get.find<StorageService>(),
      ),
    );
  }
}
