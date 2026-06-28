import 'package:hive/hive.dart';
import '../../domain/entities/conversation_entity.dart';

part 'conversation_model.g.dart';

@HiveType(typeId: 1)
class ConversationModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? lastMessage;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;

  @HiveField(5)
  String model;

  @HiveField(6)
  String? systemPrompt;

  @HiveField(7)
  int messageCount;

  ConversationModel({
    required this.id,
    required this.title,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    required this.model,
    this.systemPrompt,
    this.messageCount = 0,
  });

  factory ConversationModel.fromEntity(ConversationEntity entity) => ConversationModel(
        id: entity.id,
        title: entity.title,
        lastMessage: entity.lastMessage,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        model: entity.model,
        systemPrompt: entity.systemPrompt,
        messageCount: entity.messageCount,
      );

  ConversationEntity toEntity() => ConversationEntity(
        id: id,
        title: title,
        lastMessage: lastMessage,
        createdAt: createdAt,
        updatedAt: updatedAt,
        model: model,
        systemPrompt: systemPrompt,
        messageCount: messageCount,
      );
}
