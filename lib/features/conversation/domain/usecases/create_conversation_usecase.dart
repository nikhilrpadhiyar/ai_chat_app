import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/conversation_entity.dart';
import '../repositories/conversation_repository.dart';

class CreateConversationUseCase {
  final ConversationRepository _repository;
  const CreateConversationUseCase(this._repository);

  Future<Either<Failure, ConversationEntity>> call(ConversationEntity conversation) =>
      _repository.createConversation(conversation);
}
