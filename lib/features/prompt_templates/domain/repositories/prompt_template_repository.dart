import 'package:ai_chat_app/core/error/failures.dart';
import 'package:ai_chat_app/features/prompt_templates/domain/entities/prompt_template_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PromptTemplateRepository {
  Future<Either<Failure, List<PromptTemplateEntity>>> getAllTemplates();
  Future<Either<Failure, PromptTemplateEntity>> saveTemplate(
    PromptTemplateEntity template,
  );
  Future<Either<Failure, void>> deleteTemplate(String id);
}
