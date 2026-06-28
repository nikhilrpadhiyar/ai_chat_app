import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository _repository;
  const SendMessageUseCase(this._repository);

  Stream<Either<Failure, String>> call({
    required String conversationId,
    required List<MessageEntity> history,
    required String userMessage,
    required String model,
    String? systemPrompt,
  }) =>
      _repository.sendMessageStream(
        conversationId: conversationId,
        history: history,
        userMessage: userMessage,
        model: model,
        systemPrompt: systemPrompt,
      );
}
