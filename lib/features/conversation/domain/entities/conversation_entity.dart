import 'package:equatable/equatable.dart';

class ConversationEntity extends Equatable {
  final String id;
  final String title;
  final String? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String model;
  final String? systemPrompt;
  final int messageCount;

  const ConversationEntity({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.model,
    this.lastMessage,
    this.systemPrompt,
    this.messageCount = 0,
  });

  ConversationEntity copyWith({
    String? title,
    String? lastMessage,
    DateTime? updatedAt,
    String? model,
    String? systemPrompt,
    int? messageCount,
  }) =>
      ConversationEntity(
        id: id,
        title: title ?? this.title,
        lastMessage: lastMessage ?? this.lastMessage,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        model: model ?? this.model,
        systemPrompt: systemPrompt ?? this.systemPrompt,
        messageCount: messageCount ?? this.messageCount,
      );

  @override
  List<Object?> get props =>
      [id, title, lastMessage, createdAt, updatedAt, model, systemPrompt, messageCount];
}
