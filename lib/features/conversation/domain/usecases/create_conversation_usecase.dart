import 'package:ai_chat_app/core/error/failures.dart';
import 'package:ai_chat_app/features/conversation/domain/entities/conversation_entity.dart';
import 'package:ai_chat_app/features/conversation/domain/repositories/conversation_repository.dart';
import 'package:dartz/dartz.dart';

class CreateConversationUseCase {
  const CreateConversationUseCase(this._repository);
  final ConversationRepository _repository;

  Future<Either<Failure, ConversationEntity>> call(
    ConversationEntity conversation,
  ) => _repository.createConversation(conversation);
}
