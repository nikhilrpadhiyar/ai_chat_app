abstract class AppConstants {
  // Hive box names
  static const String conversationsBox = 'conversations_box';
  static const String messagesBox = 'messages_box';
  static const String promptTemplatesBox = 'prompt_templates_box';

  // Secure storage keys
  static const String apiKeyKey = 'anthropic_api_key';

  // GetStorage keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language_code';
  static const String selectedModelKey = 'selected_model';
  static const String systemPromptKey = 'system_prompt';

  // AI models
  static const String defaultModel = 'claude-sonnet-4-6';
  static const List<String> availableModels = [
    'claude-sonnet-4-6',
    'claude-haiku-4-5-20251001',
    'claude-opus-4-8',
  ];

  // Pagination
  static const int messagePageSize = 50;
  static const int maxTokens = 8192;
  static const double defaultTemperature = 0.7;

  // Voice
  static const Duration voiceListenTimeout = Duration(seconds: 30);
  static const Duration voicePauseTimeout = Duration(seconds: 3);
}
