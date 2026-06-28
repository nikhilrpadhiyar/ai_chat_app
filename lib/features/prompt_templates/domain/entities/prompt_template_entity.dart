import 'package:equatable/equatable.dart';

class PromptTemplateEntity extends Equatable {
  final String id;
  final String name;
  final String prompt;
  final String? description;
  final String? emoji;
  final bool isBuiltIn;
  final DateTime createdAt;

  const PromptTemplateEntity({
    required this.id,
    required this.name,
    required this.prompt,
    this.description,
    this.emoji,
    this.isBuiltIn = false,
    required this.createdAt,
  });

  PromptTemplateEntity copyWith({
    String? name,
    String? prompt,
    String? description,
    String? emoji,
  }) =>
      PromptTemplateEntity(
        id: id,
        name: name ?? this.name,
        prompt: prompt ?? this.prompt,
        description: description ?? this.description,
        emoji: emoji ?? this.emoji,
        isBuiltIn: isBuiltIn,
        createdAt: createdAt,
      );

  @override
  List<Object?> get props => [id, name, prompt, description, emoji, isBuiltIn, createdAt];
}

// Built-in templates
abstract class BuiltInTemplates {
  static List<PromptTemplateEntity> get all => [
        PromptTemplateEntity(
          id: 'builtin_code_review',
          name: 'Code Review',
          emoji: '🔍',
          description: 'Review my code for bugs, performance, and best practices',
          prompt:
              'Please review the following code. Look for bugs, performance issues, security concerns, and suggest improvements following best practices:\n\n',
          isBuiltIn: true,
          createdAt: DateTime(2024),
        ),
        PromptTemplateEntity(
          id: 'builtin_explain',
          name: 'Explain Like I\'m 5',
          emoji: '🧒',
          description: 'Explain a concept in simple terms',
          prompt: 'Please explain the following concept in simple, easy-to-understand terms, as if explaining to someone with no technical background:\n\n',
          isBuiltIn: true,
          createdAt: DateTime(2024),
        ),
        PromptTemplateEntity(
          id: 'builtin_debug',
          name: 'Debug Helper',
          emoji: '🐛',
          description: 'Help identify and fix bugs',
          prompt:
              'I\'m encountering a bug. Please help me understand what\'s wrong and how to fix it:\n\nError/Issue:\n\nCode:\n\n',
          isBuiltIn: true,
          createdAt: DateTime(2024),
        ),
        PromptTemplateEntity(
          id: 'builtin_write',
          name: 'Writing Assistant',
          emoji: '✍️',
          description: 'Improve or help write content',
          prompt: 'Please help me write or improve the following content. Make it clear, engaging, and professional:\n\n',
          isBuiltIn: true,
          createdAt: DateTime(2024),
        ),
        PromptTemplateEntity(
          id: 'builtin_brainstorm',
          name: 'Brainstorm Ideas',
          emoji: '💡',
          description: 'Generate creative ideas on a topic',
          prompt: 'I need creative ideas about the following topic. Please give me a diverse range of suggestions:\n\n',
          isBuiltIn: true,
          createdAt: DateTime(2024),
        ),
        PromptTemplateEntity(
          id: 'builtin_summarize',
          name: 'Summarize',
          emoji: '📋',
          description: 'Summarize text or content',
          prompt:
              'Please provide a concise summary of the following, highlighting the key points:\n\n',
          isBuiltIn: true,
          createdAt: DateTime(2024),
        ),
      ];
}
