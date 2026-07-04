import 'package:ai_chat_app/core/error/failures.dart';
import 'package:ai_chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:ai_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class SendMessageUseCase {
  const SendMessageUseCase(this._repository);
  final ChatRepository _repository;

  Stream<Either<Failure, String>> call({
    required String conversationId,
    required List<MessageEntity> history,
    required String userMessage,
    required String model,
    String? systemPrompt,
  }) => _repository.sendMessageStream(
    conversationId: conversationId,
    history: history,
    userMessage: userMessage,
    model: model,
    systemPrompt: systemPrompt,
  );
}
