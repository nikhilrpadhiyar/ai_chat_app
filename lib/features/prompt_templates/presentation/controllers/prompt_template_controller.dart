import 'package:ai_chat_app/core/error/failures.dart';
import 'package:ai_chat_app/features/prompt_templates/domain/entities/prompt_template_entity.dart';
import 'package:ai_chat_app/features/prompt_templates/domain/repositories/prompt_template_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class PromptTemplateController extends GetxController {
  PromptTemplateController(this._repository);
  final PromptTemplateRepository _repository;

  final RxList<PromptTemplateEntity> templates = <PromptTemplateEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  final Uuid _uuid = const Uuid();

  @override
  void onInit() {
    super.onInit();
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    isLoading.value = true;
    final Either<Failure, List<PromptTemplateEntity>> result = await _repository
        .getAllTemplates();
    result.fold(
      (Failure f) => errorMessage.value = f.message,
      (List<PromptTemplateEntity> list) => templates.assignAll(list),
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
    final DateTime now = DateTime.now();
    final PromptTemplateEntity template = PromptTemplateEntity(
      id: existingId ?? _uuid.v4(),
      name: name.trim(),
      prompt: prompt.trim(),
      description: description?.trim(),
      emoji: emoji,
      createdAt: existingId != null
          ? templates
                .firstWhere((PromptTemplateEntity t) => t.id == existingId)
                .createdAt
          : now,
    );

    final Either<Failure, PromptTemplateEntity> result = await _repository
        .saveTemplate(template);
    result.fold((Failure f) => errorMessage.value = f.message, (
      PromptTemplateEntity saved,
    ) {
      final int idx = templates.indexWhere(
        (PromptTemplateEntity t) => t.id == saved.id,
      );
      if (idx != -1) {
        templates[idx] = saved;
      } else {
        templates.add(saved);
      }
    });
  }

  Future<void> deleteTemplate(String id) async {
    // Prevent deleting built-in templates
    final PromptTemplateEntity? template = templates.firstWhereOrNull(
      (PromptTemplateEntity t) => t.id == id,
    );
    if (template?.isBuiltIn == true) {
      Get.snackbar('Cannot Delete', 'Built-in templates cannot be deleted');
      return;
    }

    final Either<Failure, void> result = await _repository.deleteTemplate(id);
    result.fold(
      (Failure f) => errorMessage.value = f.message,
      (_) => templates.removeWhere((PromptTemplateEntity t) => t.id == id),
    );
  }
}
