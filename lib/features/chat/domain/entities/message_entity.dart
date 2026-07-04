import 'package:equatable/equatable.dart';

enum MessageRole { user, assistant, system }

enum MessageStatus { sending, sent, error, streaming }

class MessageEntity extends Equatable {
  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.role,
    required this.content,
    required this.status,
    required this.createdAt,
    this.tokenCount,
  });
  final String id;
  final String conversationId;
  final MessageRole role;
  final String content;
  final MessageStatus status;
  final DateTime createdAt;
  final int? tokenCount;

  bool get isUser => role == MessageRole.user;
  bool get isAssistant => role == MessageRole.assistant;
  bool get isStreaming => status == MessageStatus.streaming;
  bool get hasError => status == MessageStatus.error;

  MessageEntity copyWith({
    String? content,
    MessageStatus? status,
    int? tokenCount,
  }) => MessageEntity(
    id: id,
    conversationId: conversationId,
    role: role,
    content: content ?? this.content,
    status: status ?? this.status,
    createdAt: createdAt,
    tokenCount: tokenCount ?? this.tokenCount,
  );

  @override
  List<Object?> get props => <Object?>[
    id,
    conversationId,
    role,
    content,
    status,
    createdAt,
    tokenCount,
  ];
}
