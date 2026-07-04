import 'package:ai_chat_app/core/error/failures.dart';
import 'package:ai_chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:ai_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class GetMessagesUseCase {
  const GetMessagesUseCase(this._repository);
  final ChatRepository _repository;

  Future<Either<Failure, List<MessageEntity>>> call(String conversationId) =>
      _repository.getMessages(conversationId);
}
