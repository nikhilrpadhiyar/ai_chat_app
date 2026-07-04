import 'package:ai_chat_app/features/prompt_templates/data/datasources/prompt_template_local_datasource.dart';
import 'package:ai_chat_app/features/prompt_templates/data/repositories/prompt_template_repository_impl.dart';
import 'package:ai_chat_app/features/prompt_templates/presentation/controllers/prompt_template_controller.dart';
import 'package:get/get.dart';

class PromptTemplateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PromptTemplateLocalDataSource(), fenix: true);
    Get.lazyPut(
      () => PromptTemplateRepositoryImpl(
        Get.find<PromptTemplateLocalDataSource>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => PromptTemplateController(Get.find<PromptTemplateRepositoryImpl>()),
    );
  }
}
