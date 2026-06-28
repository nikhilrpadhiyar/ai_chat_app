import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/storage/storage_service.dart';
import '../../data/datasources/chat_local_datasource.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import 'chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatRemoteDataSource(Get.find<ApiClient>()));
    Get.lazyPut(() => ChatLocalDataSource());
    Get.lazyPut(() => ChatRepositoryImpl(
          Get.find<ChatRemoteDataSource>(),
          Get.find<ChatLocalDataSource>(),
        ));
    Get.lazyPut(() => SendMessageUseCase(Get.find<ChatRepositoryImpl>()));
    Get.lazyPut(() => GetMessagesUseCase(Get.find<ChatRepositoryImpl>()));
    Get.lazyPut(() => ChatController(
          Get.find<SendMessageUseCase>(),
          Get.find<GetMessagesUseCase>(),
          Get.find<StorageService>(),
        ));
  }
}
