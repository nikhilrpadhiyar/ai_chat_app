import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/conversation_model.dart';

class ConversationLocalDataSource {
  Box<ConversationModel> get _box =>
      Hive.box<ConversationModel>(AppConstants.conversationsBox);

  List<ConversationModel> getAll() {
    try {
      return _box.values.toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (e) {
      throw CacheException('Failed to load conversations: $e');
    }
  }

  ConversationModel? getById(String id) {
    try {
      return _box.get(id);
    } catch (e) {
      throw CacheException('Failed to get conversation: $e');
    }
  }

  Future<void> save(ConversationModel model) async {
    try {
      await _box.put(model.id, model);
    } catch (e) {
      throw CacheException('Failed to save conversation: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      throw CacheException('Failed to delete conversation: $e');
    }
  }

  Stream<List<ConversationModel>> watch() {
    return _box.watch().map((_) => getAll());
  }
}
