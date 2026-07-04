import 'package:ai_chat_app/core/error/failures.dart';
import 'package:ai_chat_app/features/conversation/domain/repositories/conversation_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteConversationUseCase {
  const DeleteConversationUseCase(this._repository);
  final ConversationRepository _repository;

  Future<Either<Failure, void>> call(String id) =>
      _repository.deleteConversation(id);
}
