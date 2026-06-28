import 'package:hive/hive.dart';
import '../../domain/entities/message_entity.dart';

part 'message_model.g.dart';

@HiveType(typeId: 0)
class MessageModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String conversationId;

  @HiveField(2)
  final int roleIndex;

  @HiveField(3)
  String content;

  @HiveField(4)
  int statusIndex;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  int? tokenCount;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.roleIndex,
    required this.content,
    required this.statusIndex,
    required this.createdAt,
    this.tokenCount,
  });

  factory MessageModel.fromEntity(MessageEntity entity) => MessageModel(
        id: entity.id,
        conversationId: entity.conversationId,
        roleIndex: entity.role.index,
        content: entity.content,
        statusIndex: entity.status.index,
        createdAt: entity.createdAt,
        tokenCount: entity.tokenCount,
      );

  MessageEntity toEntity() => MessageEntity(
        id: id,
        conversationId: conversationId,
        role: MessageRole.values[roleIndex],
        content: content,
        status: MessageStatus.values[statusIndex],
        createdAt: createdAt,
        tokenCount: tokenCount,
      );

  Map<String, dynamic> toApiMap() => {
        'role': MessageRole.values[roleIndex] == MessageRole.user ? 'user' : 'assistant',
        'content': content,
      };
}
