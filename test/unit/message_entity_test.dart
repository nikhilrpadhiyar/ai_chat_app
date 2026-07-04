import 'package:ai_chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final MessageEntity baseMessage = MessageEntity(
    id: 'msg-1',
    conversationId: 'conv-1',
    role: MessageRole.user,
    content: 'Hello, Claude!',
    status: MessageStatus.sent,
    createdAt: DateTime(2024, 6, 1, 10, 30),
  );

  group('MessageEntity', () {
    test('isUser returns true for user role', () {
      expect(baseMessage.isUser, isTrue);
      expect(baseMessage.isAssistant, isFalse);
    });

    test('isAssistant returns true for assistant role', () {
      baseMessage.copyWith(content: 'Hi!');
      // Role is immutable via copyWith; create a new entity to test
      final MessageEntity assistantMsg = MessageEntity(
        id: 'msg-2',
        conversationId: 'conv-1',
        role: MessageRole.assistant,
        content: 'Hello back!',
        status: MessageStatus.sent,
        createdAt: DateTime.now(),
      );
      expect(assistantMsg.isAssistant, isTrue);
      expect(assistantMsg.isUser, isFalse);
    });

    test('isStreaming returns true when status is streaming', () {
      final MessageEntity streaming = MessageEntity(
        id: 'msg-3',
        conversationId: 'conv-1',
        role: MessageRole.assistant,
        content: '',
        status: MessageStatus.streaming,
        createdAt: DateTime.now(),
      );
      expect(streaming.isStreaming, isTrue);
    });

    test('hasError returns true when status is error', () {
      final MessageEntity errMsg = MessageEntity(
        id: 'msg-4',
        conversationId: 'conv-1',
        role: MessageRole.assistant,
        content: '(No response)',
        status: MessageStatus.error,
        createdAt: DateTime.now(),
      );
      expect(errMsg.hasError, isTrue);
    });

    test('copyWith updates content and status', () {
      final MessageEntity updated = baseMessage.copyWith(
        content: 'Updated content',
        status: MessageStatus.error,
      );
      expect(updated.content, 'Updated content');
      expect(updated.status, MessageStatus.error);
      expect(updated.id, baseMessage.id);
      expect(updated.role, baseMessage.role);
    });

    test('equality is value-based via Equatable', () {
      final MessageEntity copy = MessageEntity(
        id: baseMessage.id,
        conversationId: baseMessage.conversationId,
        role: baseMessage.role,
        content: baseMessage.content,
        status: baseMessage.status,
        createdAt: baseMessage.createdAt,
      );
      expect(baseMessage, equals(copy));
    });
  });
}
