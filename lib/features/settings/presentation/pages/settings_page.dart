import 'package:ai_chat_app/core/constants/app_constants.dart';
import 'package:ai_chat_app/core/theme/app_colors.dart';
import 'package:ai_chat_app/core/theme/app_text_styles.dart';
import 'package:ai_chat_app/features/settings/presentation/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController controller = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: <Widget>[
          _Section(
            title: 'API Configuration',
            children: <Widget>[
              Obx(
                () => ListTile(
                  leading: Icon(
                    controller.hasApiKey.value
                        ? Icons.lock
                        : Icons.lock_open_outlined,
                    color: controller.hasApiKey.value
                        ? AppColors.success
                        : AppColors.warning,
                  ),
                  title: const Text('Anthropic API Key'),
                  subtitle: Text(
                    controller.hasApiKey.value
                        ? 'Key saved securely'
                        : 'No API key configured',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: controller.hasApiKey.value
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ),
                  trailing: TextButton(
                    onPressed: () => _showApiKeyDialog(context, controller),
                    child: Text(
                      controller.hasApiKey.value ? 'Update' : 'Add Key',
                    ),
                  ),
                ),
              ),
              if (true)
                Obx(
                  () => controller.hasApiKey.value
                      ? ListTile(
                          leading: const Icon(
                            Icons.delete_outlined,
                            color: AppColors.error,
                          ),
                          title: const Text('Remove API Key'),
                          textColor: AppColors.error,
                          onTap: controller.deleteApiKey,
                        )
                      : const SizedBox.shrink(),
                ),
            ],
          ),
          _Section(
            title: 'AI Model',
            children: <Widget>[
              Obx(
                () => Column(
                  children: AppConstants.availableModels
                      .map(
                        (String model) => RadioListTile<String>(
                          title: Text(model, style: AppTextStyles.bodyMedium),
                          value: model,
                          groupValue: controller.selectedModel.value,
                          onChanged: (String? v) {
                            if (v != null) controller.changeModel(v);
                          },
                          activeColor: AppColors.primary,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
          _Section(
            title: 'System Prompt',
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Set a default system prompt for all conversations',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => TextField(
                        controller:
                            TextEditingController(
                                text: controller.systemPrompt.value,
                              )
                              ..selection = TextSelection.collapsed(
                                offset: controller.systemPrompt.value.length,
                              ),
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText:
                              'e.g., You are a helpful coding assistant...',
                        ),
                        onChanged: controller.updateSystemPrompt,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          _Section(
            title: 'Appearance',
            children: <Widget>[
              Obx(
                () => SwitchListTile(
                  title: const Text('Dark Mode'),
                  secondary: const Icon(Icons.dark_mode_outlined),
                  value: controller.isDarkMode.value,
                  onChanged: (_) => controller.toggleTheme(),
                  activeThumbColor: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Your API key is stored securely using the device keychain/keystore and is never transmitted to any server other than api.anthropic.com.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showApiKeyDialog(BuildContext context, SettingsController controller) {
    final TextEditingController textCtrl = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final RxBool obscure = true.obs;

    Get.dialog(
      AlertDialog(
        title: const Text('Anthropic API Key'),
        content: Form(
          key: formKey,
          child: Obx(
            () => TextFormField(
              controller: textCtrl,
              obscureText: obscure.value,
              decoration: InputDecoration(
                hintText: 'sk-ant-api03-...',
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure.value ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => obscure.value = !obscure.value,
                ),
              ),
              validator: (String? v) {
                if (v == null || v.trim().isEmpty) return 'Key is required';
                if (!v.trim().startsWith('sk-ant-')) {
                  return 'Must start with sk-ant-';
                }
                return null;
              },
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              Get.back();
              await controller.saveApiKey(textCtrl.text);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
          child: Text(
            title.toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.primary,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...children,
        const Divider(height: 1),
      ],
    );
  }
}
