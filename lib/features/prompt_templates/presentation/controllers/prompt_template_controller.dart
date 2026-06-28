import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/prompt_template_entity.dart';
import '../../domain/repositories/prompt_template_repository.dart';

class PromptTemplateController extends GetxController {
  final PromptTemplateRepository _repository;

  PromptTemplateController(this._repository);

  final templates = <PromptTemplateEntity>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();
  final _uuid = const Uuid();

  @override
  void onInit() {
    super.onInit();
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    isLoading.value = true;
    final result = await _repository.getAllTemplates();
    result.fold(
      (f) => errorMessage.value = f.message,
      (list) => templates.assignAll(list),
    );
    isLoading.value = false;
  }

  Future<void> saveTemplate({
    required String name,
    required String prompt,
    String? description,
    String? emoji,
    String? existingId,
  }) async {
    final now = DateTime.now();
    final template = PromptTemplateEntity(
      id: existingId ?? _uuid.v4(),
      name: name.trim(),
      prompt: prompt.trim(),
      description: description?.trim(),
      emoji: emoji,
      createdAt: existingId != null
          ? templates.firstWhere((t) => t.id == existingId).createdAt
          : now,
    );

    final result = await _repository.saveTemplate(template);
    result.fold(
      (f) => errorMessage.value = f.message,
      (saved) {
        final idx = templates.indexWhere((t) => t.id == saved.id);
        if (idx != -1) {
          templates[idx] = saved;
        } else {
          templates.add(saved);
        }
      },
    );
  }

  Future<void> deleteTemplate(String id) async {
    // Prevent deleting built-in templates
    final template = templates.firstWhereOrNull((t) => t.id == id);
    if (template?.isBuiltIn == true) {
      Get.snackbar('Cannot Delete', 'Built-in templates cannot be deleted');
      return;
    }

    final result = await _repository.deleteTemplate(id);
    result.fold(
      (f) => errorMessage.value = f.message,
      (_) => templates.removeWhere((t) => t.id == id),
    );
  }
}
