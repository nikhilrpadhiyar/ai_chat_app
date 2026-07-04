import 'package:ai_chat_app/core/error/exceptions.dart';
import 'package:ai_chat_app/core/error/failures.dart';
import 'package:ai_chat_app/features/conversation/data/datasources/conversation_local_datasource.dart';
import 'package:ai_chat_app/features/conversation/data/models/conversation_model.dart';
import 'package:ai_chat_app/features/conversation/domain/entities/conversation_entity.dart';
import 'package:ai_chat_app/features/conversation/domain/repositories/conversation_repository.dart';
import 'package:dartz/dartz.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  ConversationRepositoryImpl(this._local);

  final ConversationLocalDataSource _local;

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversations() async {
    try {
      final List<ConversationModel> models = _local.getAll();
      return Right<Failure, List<ConversationEntity>>(
        models.map((ConversationModel m) => m.toEntity()).toList(),
      );
    } on CacheException catch (e) {
      return Left<Failure, List<ConversationEntity>>(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ConversationEntity>> getConversation(String id) async {
    try {
      final ConversationModel? model = _local.getById(id);
      if (model == null) {
        return const Left<Failure, ConversationEntity>(
          CacheFailure('Conversation not found'),
        );
      }
      return Right<Failure, ConversationEntity>(model.toEntity());
    } on CacheException catch (e) {
      return Left<Failure, ConversationEntity>(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ConversationEntity>> createConversation(
    ConversationEntity conversation,
  ) async {
    try {
      final ConversationModel model = ConversationModel.fromEntity(
        conversation,
      );
      await _local.save(model);
      return Right<Failure, ConversationEntity>(conversation);
    } on CacheException catch (e) {
      return Left<Failure, ConversationEntity>(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateConversation(
    ConversationEntity conversation,
  ) async {
    try {
      final ConversationModel model = ConversationModel.fromEntity(
        conversation,
      );
      await _local.save(model);
      return const Right<Failure, void>(null);
    } on CacheException catch (e) {
      return Left<Failure, void>(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteConversation(String id) async {
    try {
      await _local.delete(id);
      return const Right<Failure, void>(null);
    } on CacheException catch (e) {
      return Left<Failure, void>(CacheFailure(e.message));
    }
  }

  @override
  Stream<List<ConversationEntity>> watchConversations() {
    return _local.watch().map(
      (List<ConversationModel> models) =>
          models.map((ConversationModel m) => m.toEntity()).toList(),
    );
  }
}
