import 'package:ai_chat_app/core/error/failures.dart';
import 'package:ai_chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  /// Streams tokens as they arrive from the AI API.
  Stream<Either<Failure, String>> sendMessageStream({
    required String conversationId,
    required List<MessageEntity> history,
    required String userMessage,
    required String model,
    String? systemPrompt,
  });

  /// Saves a message to local storage.
  Future<Either<Failure, void>> saveMessage(MessageEntity message);

  /// Returns all messages for a conversation (ordered oldest first).
  Future<Either<Failure, List<MessageEntity>>> getMessages(
    String conversationId,
  );

  /// Deletes a single message.
  Future<Either<Failure, void>> deleteMessage(String messageId);

  /// Deletes all messages in a conversation.
  Future<Either<Failure, void>> clearMessages(String conversationId);
}
