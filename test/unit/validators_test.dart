import 'package:flutter_test/flutter_test.dart';
import 'package:ai_chat_app/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('returns error on null', () {
      expect(Validators.email(null), isNotNull);
    });

    test('returns error on empty', () {
      expect(Validators.email(''), isNotNull);
    });

    test('returns error on invalid format', () {
      expect(Validators.email('notanemail'), isNotNull);
      expect(Validators.email('user@'), isNotNull);
      expect(Validators.email('@domain.com'), isNotNull);
    });

    test('returns null on valid email', () {
      expect(Validators.email('user@example.com'), isNull);
      expect(Validators.email('test.name+tag@domain.co.uk'), isNull);
    });
  });

  group('Validators.apiKey', () {
    test('returns error on null or empty', () {
      expect(Validators.apiKey(null), isNotNull);
      expect(Validators.apiKey(''), isNotNull);
    });

    test('returns error if not starting with sk-ant-', () {
      expect(Validators.apiKey('sk-proj-12345'), isNotNull);
      expect(Validators.apiKey('openai-key'), isNotNull);
    });

    test('returns null for valid anthropic key prefix', () {
      expect(Validators.apiKey('sk-ant-api03-abc123'), isNull);
    });
  });

  group('Validators.password', () {
    test('returns error on null or empty', () {
      expect(Validators.password(null), isNotNull);
      expect(Validators.password(''), isNotNull);
    });

    test('returns error on too short', () {
      expect(Validators.password('abc'), isNotNull);
    });

    test('returns null on valid password', () {
      expect(Validators.password('password123'), isNull);
    });
  });
}
