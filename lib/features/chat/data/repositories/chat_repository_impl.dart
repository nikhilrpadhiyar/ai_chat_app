import 'package:ai_chat_app/core/error/exceptions.dart';
import 'package:ai_chat_app/core/error/failures.dart';
import 'package:ai_chat_app/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:ai_chat_app/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:ai_chat_app/features/chat/data/models/message_model.dart';
import 'package:ai_chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:ai_chat_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl(this._remote, this._local);
  final ChatRemoteDataSource _remote;
  final ChatLocalDataSource _local;

  @override
  Stream<Either<Failure, String>> sendMessageStream({
    required String conversationId,
    required List<MessageEntity> history,
    required String userMessage,
    required String model,
    String? systemPrompt,
  }) async* {
    try {
      yield* _remote
          .sendMessageStream(
            history: history,
            userMessage: userMessage,
            model: model,
            systemPrompt: systemPrompt,
          )
          .map((String token) => Right<Failure, String>(token));
    } on UnauthorizedException catch (e) {
      yield Left<Failure, String>(UnauthorizedFailure(e.message));
    } on RateLimitException catch (e) {
      yield Left<Failure, String>(RateLimitFailure(e.message));
    } on NetworkException catch (e) {
      yield Left<Failure, String>(NetworkFailure(e.message));
    } on StreamException catch (e) {
      yield Left<Failure, String>(StreamFailure(e.message));
    } on AppException catch (e) {
      yield Left<Failure, String>(ApiFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveMessage(MessageEntity message) async {
    try {
      await _local.saveMessage(MessageModel.fromEntity(message));
      return const Right<Failure, void>(null);
    } on CacheException catch (e) {
      return Left<Failure, void>(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(
    String conversationId,
  ) async {
    try {
      final List<MessageModel> models = _local.getMessages(conversationId);
      return Right<Failure, List<MessageEntity>>(
        models.map((MessageModel m) => m.toEntity()).toList(),
      );
    } on CacheException catch (e) {
      return Left<Failure, List<MessageEntity>>(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(String messageId) async {
    try {
      await _local.deleteMessage(messageId);
      return const Right<Failure, void>(null);
    } on CacheException catch (e) {
      return Left<Failure, void>(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearMessages(String conversationId) async {
    try {
      await _local.clearMessages(conversationId);
      return const Right<Failure, void>(null);
    } on CacheException catch (e) {
      return Left<Failure, void>(CacheFailure(e.message));
    }
  }
}
