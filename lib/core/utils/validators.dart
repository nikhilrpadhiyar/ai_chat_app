abstract class Validators {
  static String? required(String? value, [String field = 'This field']) {
    if (value == null || value.trim().isEmpty) return '$field is required';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    final RegExp regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!regex.hasMatch(value.trim())) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? apiKey(String? value) {
    if (value == null || value.trim().isEmpty) return 'API key is required';
    if (!value.trim().startsWith('sk-ant-')) {
      return 'Enter a valid Anthropic API key (starts with sk-ant-)';
    }
    return null;
  }

  static String? promptTemplateName(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Template name is required';
    if (value.trim().length < 3) return 'Name must be at least 3 characters';
    return null;
  }
}
