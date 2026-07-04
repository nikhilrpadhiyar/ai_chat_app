import 'package:ai_chat_app/features/conversation/domain/entities/conversation_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ConversationEntity base = ConversationEntity(
    id: 'conv-1',
    title: 'New Chat',
    createdAt: DateTime(2024, 6, 1),
    updatedAt: DateTime(2024, 6, 1),
    model: 'claude-sonnet-4-6',
  );

  group('ConversationEntity', () {
    test('copyWith updates only specified fields', () {
      final ConversationEntity updated = base.copyWith(
        title: 'My Chat',
        messageCount: 5,
      );
      expect(updated.title, 'My Chat');
      expect(updated.messageCount, 5);
      expect(updated.id, base.id);
      expect(updated.model, base.model);
    });

    test('equality is value-based via Equatable', () {
      final ConversationEntity copy = ConversationEntity(
        id: base.id,
        title: base.title,
        createdAt: base.createdAt,
        updatedAt: base.updatedAt,
        model: base.model,
      );
      expect(base, equals(copy));
    });

    test('messageCount defaults to 0', () {
      expect(base.messageCount, 0);
    });
  });
}
