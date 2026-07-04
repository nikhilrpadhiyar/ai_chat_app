import 'package:ai_chat_app/core/error/failures.dart';
import 'package:ai_chat_app/features/conversation/domain/entities/conversation_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ConversationRepository {
  Future<Either<Failure, List<ConversationEntity>>> getConversations();
  Future<Either<Failure, ConversationEntity>> getConversation(String id);
  Future<Either<Failure, ConversationEntity>> createConversation(
    ConversationEntity conversation,
  );
  Future<Either<Failure, void>> updateConversation(
    ConversationEntity conversation,
  );
  Future<Either<Failure, void>> deleteConversation(String id);
  Stream<List<ConversationEntity>> watchConversations();
}
