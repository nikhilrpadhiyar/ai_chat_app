import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/message_model.dart';

class ChatLocalDataSource {
  Box<MessageModel> get _box => Hive.box<MessageModel>(AppConstants.messagesBox);

  Future<void> saveMessage(MessageModel model) async {
    try {
      await _box.put(model.id, model);
    } catch (e) {
      throw CacheException('Failed to save message: $e');
    }
  }

  List<MessageModel> getMessages(String conversationId) {
    try {
      return _box.values
          .where((m) => m.conversationId == conversationId)
          .toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } catch (e) {
      throw CacheException('Failed to load messages: $e');
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      await _box.delete(messageId);
    } catch (e) {
      throw CacheException('Failed to delete message: $e');
    }
  }

  Future<void> clearMessages(String conversationId) async {
    try {
      final keys = _box.values
          .where((m) => m.conversationId == conversationId)
          .map((m) => m.id)
          .toList();
      await _box.deleteAll(keys);
    } catch (e) {
      throw CacheException('Failed to clear messages: $e');
    }
  }
}
