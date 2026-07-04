import 'package:ai_chat_app/core/error/failures.dart';
import 'package:ai_chat_app/features/conversation/domain/entities/conversation_entity.dart';
import 'package:ai_chat_app/features/conversation/domain/repositories/conversation_repository.dart';
import 'package:dartz/dartz.dart';

class GetConversationsUseCase {
  const GetConversationsUseCase(this._repository);
  final ConversationRepository _repository;

  Future<Either<Failure, List<ConversationEntity>>> call() =>
      _repository.getConversations();
}
