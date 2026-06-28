import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remote;
  final ChatLocalDataSource _local;

  ChatRepositoryImpl(this._remote, this._local);

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
          .map((token) => Right<Failure, String>(token));
    } on UnauthorizedException catch (e) {
      yield Left(UnauthorizedFailure(e.message));
    } on RateLimitException catch (e) {
      yield Left(RateLimitFailure(e.message));
    } on NetworkException catch (e) {
      yield Left(NetworkFailure(e.message));
    } on StreamException catch (e) {
      yield Left(StreamFailure(e.message));
    } on AppException catch (e) {
      yield Left(ApiFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> saveMessage(MessageEntity message) async {
    try {
      await _local.saveMessage(MessageModel.fromEntity(message));
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(String conversationId) async {
    try {
      final models = _local.getMessages(conversationId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(String messageId) async {
    try {
      await _local.deleteMessage(messageId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> clearMessages(String conversationId) async {
    try {
      await _local.clearMessages(conversationId);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
