import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/prompt_template_entity.dart';
import '../../domain/repositories/prompt_template_repository.dart';
import '../datasources/prompt_template_local_datasource.dart';
import '../models/prompt_template_model.dart';

class PromptTemplateRepositoryImpl implements PromptTemplateRepository {
  final PromptTemplateLocalDataSource _local;

  PromptTemplateRepositoryImpl(this._local);

  @override
  Future<Either<Failure, List<PromptTemplateEntity>>> getAllTemplates() async {
    try {
      final stored = _local.getAll().map((m) => m.toEntity()).toList();
      // Merge built-ins with user templates (built-ins always first)
      final builtIns = BuiltInTemplates.all;
      final userTemplates = stored.where((t) => !t.isBuiltIn).toList();
      return Right([...builtIns, ...userTemplates]);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PromptTemplateEntity>> saveTemplate(
      PromptTemplateEntity template) async {
    try {
      final model = PromptTemplateModel.fromEntity(template);
      await _local.save(model);
      return Right(template);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTemplate(String id) async {
    try {
      await _local.delete(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
