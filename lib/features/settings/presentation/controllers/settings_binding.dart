import 'package:ai_chat_app/core/storage/secure_storage_service.dart';
import 'package:ai_chat_app/core/storage/storage_service.dart';
import 'package:ai_chat_app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:get/get.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SettingsController(
        Get.find<StorageService>(),
        Get.find<SecureStorageService>(),
      ),
    );
  }
}
