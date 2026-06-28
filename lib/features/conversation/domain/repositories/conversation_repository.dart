import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/conversation_entity.dart';

abstract class ConversationRepository {
  Future<Either<Failure, List<ConversationEntity>>> getConversations();
  Future<Either<Failure, ConversationEntity>> getConversation(String id);
  Future<Either<Failure, ConversationEntity>> createConversation(ConversationEntity conversation);
  Future<Either<Failure, void>> updateConversation(ConversationEntity conversation);
  Future<Either<Failure, void>> deleteConversation(String id);
  Stream<List<ConversationEntity>> watchConversations();
}
