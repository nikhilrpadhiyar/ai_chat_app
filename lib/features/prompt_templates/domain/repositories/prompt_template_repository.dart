import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/prompt_template_entity.dart';

abstract class PromptTemplateRepository {
  Future<Either<Failure, List<PromptTemplateEntity>>> getAllTemplates();
  Future<Either<Failure, PromptTemplateEntity>> saveTemplate(PromptTemplateEntity template);
  Future<Either<Failure, void>> deleteTemplate(String id);
}
