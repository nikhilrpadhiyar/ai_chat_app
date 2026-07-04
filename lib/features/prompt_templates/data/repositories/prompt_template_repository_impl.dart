import 'package:ai_chat_app/core/error/exceptions.dart';
import 'package:ai_chat_app/core/error/failures.dart';
import 'package:ai_chat_app/features/prompt_templates/data/datasources/prompt_template_local_datasource.dart';
import 'package:ai_chat_app/features/prompt_templates/data/models/prompt_template_model.dart';
import 'package:ai_chat_app/features/prompt_templates/domain/entities/prompt_template_entity.dart';
import 'package:ai_chat_app/features/prompt_templates/domain/repositories/prompt_template_repository.dart';
import 'package:dartz/dartz.dart';

class PromptTemplateRepositoryImpl implements PromptTemplateRepository {
  PromptTemplateRepositoryImpl(this._local);

  final PromptTemplateLocalDataSource _local;

  @override
  Future<Either<Failure, List<PromptTemplateEntity>>> getAllTemplates() async {
    try {
      final List<PromptTemplateEntity> stored = _local
          .getAll()
          .map((PromptTemplateModel m) => m.toEntity())
          .toList();
      // Merge built-ins with user templates (built-ins always first)
      final List<PromptTemplateEntity> builtIns = BuiltInTemplates.all;
      final List<PromptTemplateEntity> userTemplates = stored
          .where((PromptTemplateEntity t) => !t.isBuiltIn)
          .toList();
      return Right<Failure, List<PromptTemplateEntity>>(<PromptTemplateEntity>[
        ...builtIns,
        ...userTemplates,
      ]);
    } on CacheException catch (e) {
      return Left<Failure, List<PromptTemplateEntity>>(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, PromptTemplateEntity>> saveTemplate(
    PromptTemplateEntity template,
  ) async {
    try {
      final PromptTemplateModel model = PromptTemplateModel.fromEntity(
        template,
      );
      await _local.save(model);
      return Right<Failure, PromptTemplateEntity>(template);
    } on CacheException catch (e) {
      return Left<Failure, PromptTemplateEntity>(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTemplate(String id) async {
    try {
      await _local.delete(id);
      return const Right<Failure, void>(null);
    } on CacheException catch (e) {
      return Left<Failure, void>(CacheFailure(e.message));
    }
  }
}
