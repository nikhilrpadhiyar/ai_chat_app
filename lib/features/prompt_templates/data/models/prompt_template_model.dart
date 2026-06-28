import 'package:hive/hive.dart';
import '../../domain/entities/prompt_template_entity.dart';

part 'prompt_template_model.g.dart';

@HiveType(typeId: 2)
class PromptTemplateModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String prompt;

  @HiveField(3)
  String? description;

  @HiveField(4)
  String? emoji;

  @HiveField(5)
  final bool isBuiltIn;

  @HiveField(6)
  final DateTime createdAt;

  PromptTemplateModel({
    required this.id,
    required this.name,
    required this.prompt,
    this.description,
    this.emoji,
    required this.isBuiltIn,
    required this.createdAt,
  });

  factory PromptTemplateModel.fromEntity(PromptTemplateEntity entity) =>
      PromptTemplateModel(
        id: entity.id,
        name: entity.name,
        prompt: entity.prompt,
        description: entity.description,
        emoji: entity.emoji,
        isBuiltIn: entity.isBuiltIn,
        createdAt: entity.createdAt,
      );

  PromptTemplateEntity toEntity() => PromptTemplateEntity(
        id: id,
        name: name,
        prompt: prompt,
        description: description,
        emoji: emoji,
        isBuiltIn: isBuiltIn,
        createdAt: createdAt,
      );
}
