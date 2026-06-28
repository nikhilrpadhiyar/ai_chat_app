import 'package:get/get.dart';
import '../../data/datasources/prompt_template_local_datasource.dart';
import '../../data/repositories/prompt_template_repository_impl.dart';
import 'prompt_template_controller.dart';

class PromptTemplateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PromptTemplateLocalDataSource(), fenix: true);
    Get.lazyPut(() => PromptTemplateRepositoryImpl(
          Get.find<PromptTemplateLocalDataSource>(),
        ), fenix: true);
    Get.lazyPut(() => PromptTemplateController(
          Get.find<PromptTemplateRepositoryImpl>(),
        ));
  }
}
