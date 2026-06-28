import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/prompt_template_model.dart';

class PromptTemplateLocalDataSource {
  Box<PromptTemplateModel> get _box =>
      Hive.box<PromptTemplateModel>(AppConstants.promptTemplatesBox);

  List<PromptTemplateModel> getAll() {
    try {
      return _box.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
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
