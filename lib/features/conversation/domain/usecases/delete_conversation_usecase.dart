import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/conversation_repository.dart';

class DeleteConversationUseCase {
  final ConversationRepository _repository;
  const DeleteConversationUseCase(this._repository);

  Future<Either<Failure, void>> call(String id) =>
      _repository.deleteConversation(id);
}
