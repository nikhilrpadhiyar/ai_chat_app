import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/repositories/conversation_repository.dart';
import '../datasources/conversation_local_datasource.dart';
import '../models/conversation_model.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationLocalDataSource _local;

  ConversationRepositoryImpl(this._local);

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversations() async {
    try {
      final models = _local.getAll();
      return Right(models.map((m) => m.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ConversationEntity>> getConversation(String id) async {
    try {
      final model = _local.getById(id);
      if (model == null) return const Left(CacheFailure('Conversation not found'));
      return Right(model.toEntity());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, ConversationEntity>> createConversation(
      ConversationEntity conversation) async {
    try {
      final model = ConversationModel.fromEntity(conversation);
      await _local.save(model);
      return Right(conversation);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateConversation(ConversationEntity conversation) async {
    try {
      final model = ConversationModel.fromEntity(conversation);
      await _local.save(model);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteConversation(String id) async {
    try {
      await _local.delete(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Stream<List<ConversationEntity>> watchConversations() {
    return _local.watch().map((models) => models.map((m) => m.toEntity()).toList());
  }
}
