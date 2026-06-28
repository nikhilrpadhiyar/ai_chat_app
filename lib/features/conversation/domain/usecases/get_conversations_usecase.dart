import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/conversation_entity.dart';
import '../repositories/conversation_repository.dart';

class GetConversationsUseCase {
  final ConversationRepository _repository;
  const GetConversationsUseCase(this._repository);

  Future<Either<Failure, List<ConversationEntity>>> call() =>
      _repository.getConversations();
}
