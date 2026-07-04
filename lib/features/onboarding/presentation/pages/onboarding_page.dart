import 'package:ai_chat_app/core/constants/app_constants.dart';
import 'package:ai_chat_app/core/storage/secure_storage_service.dart';
import 'package:ai_chat_app/core/storage/storage_service.dart';
import 'package:ai_chat_app/core/theme/app_colors.dart';
import 'package:ai_chat_app/core/theme/app_text_styles.dart';
import 'package:ai_chat_app/core/utils/validators.dart';
import 'package:ai_chat_app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final TextEditingController _apiKeyCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscure = true;
  bool _saving = false;

  @override
  void dispose() {
    _apiKeyCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveAndContinue() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final SecureStorageService secureStorage = Get.find<SecureStorageService>();
    final StorageService storage = Get.find<StorageService>();
    await secureStorage.write(AppConstants.apiKeyKey, _apiKeyCtrl.text.trim());
    await storage.write('onboarding_done', true);
    Get.offAllNamed(AppRoutes.conversations);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 48),
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'AI Chat App',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
                Center(
                  child: Text(
                    'Powered by Claude',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Get Started',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your Anthropic API key to start chatting. Your key is stored securely on your device.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _apiKeyCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Anthropic API Key',
                    hintText: 'sk-ant-api03-...',
                    prefixIcon: const Icon(Icons.key_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: Validators.apiKey,
                ),
                const SizedBox(height: 8),
                Text(
                  'Get your API key from console.anthropic.com',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _saveAndContinue,
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Start Chatting'),
                  ),
                ),
                const SizedBox(height: 48),
                _FeatureRow(
                  icon: Icons.stream,
                  title: 'Streaming Responses',
                  subtitle: 'See Claude\'s replies as they\'re generated',
                ),
                _FeatureRow(
                  icon: Icons.history,
                  title: 'Conversation History',
                  subtitle: 'All chats saved locally, private by default',
                ),
                _FeatureRow(
                  icon: Icons.mic,
                  title: 'Voice Input',
                  subtitle: 'Dictate messages with your voice',
                ),
                _FeatureRow(
                  icon: Icons.text_snippet_outlined,
                  title: 'Prompt Templates',
                  subtitle: 'Quick-start with built-in or custom templates',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: AppTextStyles.titleMedium),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
