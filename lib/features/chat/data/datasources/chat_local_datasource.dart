import 'package:ai_chat_app/core/constants/app_constants.dart';
import 'package:ai_chat_app/core/error/exceptions.dart';
import 'package:ai_chat_app/features/chat/data/models/message_model.dart';
import 'package:hive/hive.dart';

class ChatLocalDataSource {
  Box<MessageModel> get _box =>
      Hive.box<MessageModel>(AppConstants.messagesBox);

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
          .where((MessageModel m) => m.conversationId == conversationId)
          .toList()
        ..sort(
          (MessageModel a, MessageModel b) =>
              a.createdAt.compareTo(b.createdAt),
        );
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
      final List<String> keys = _box.values
          .where((MessageModel m) => m.conversationId == conversationId)
          .map((MessageModel m) => m.id)
          .toList();
      await _box.deleteAll(keys);
    } catch (e) {
      throw CacheException('Failed to clear messages: $e');
    }
  }
}
