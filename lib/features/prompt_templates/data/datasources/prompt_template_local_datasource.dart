import 'package:ai_chat_app/core/constants/app_constants.dart';
import 'package:ai_chat_app/core/error/exceptions.dart';
import 'package:ai_chat_app/features/prompt_templates/data/models/prompt_template_model.dart';
import 'package:hive/hive.dart';

class PromptTemplateLocalDataSource {
  Box<PromptTemplateModel> get _box =>
      Hive.box<PromptTemplateModel>(AppConstants.promptTemplatesBox);

  List<PromptTemplateModel> getAll() {
    try {
      return _box.values.toList()..sort(
        (PromptTemplateModel a, PromptTemplateModel b) =>
            b.createdAt.compareTo(a.createdAt),
      );
    } catch (e) {
      throw CacheException('Failed to load templates: $e');
    }
  }

  Future<void> save(PromptTemplateModel model) async {
    try {
      await _box.put(model.id, model);
    } catch (e) {
      throw CacheException('Failed to save template: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete template: $e');
    }
  }
}
