import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/prompt_template_entity.dart';
import '../controllers/prompt_template_controller.dart';
import '../../../chat/presentation/controllers/chat_controller.dart';

class PromptTemplatesPage extends StatelessWidget {
  const PromptTemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PromptTemplateController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompt Templates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDialog(context, controller),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final builtIn =
            controller.templates.where((t) => t.isBuiltIn).toList();
        final custom =
            controller.templates.where((t) => !t.isBuiltIn).toList();

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (builtIn.isNotEmpty) ...[
              _SectionHeader(title: 'Built-in Templates'),
              const SizedBox(height: 8),
              ...builtIn.map((t) => _TemplateCard(
                    template: t,
                    controller: controller,
                    onUse: () => _useTemplate(context, t),
                  )),
            ],
            if (custom.isNotEmpty) ...[
              const SizedBox(height: 16),
              _SectionHeader(title: 'My Templates'),
              const SizedBox(height: 8),
              ...custom.map((t) => _TemplateCard(
                    template: t,
                    controller: controller,
                    onUse: () => _useTemplate(context, t),
                  )),
            ],
          ],
        );
      }),
    );
  }

  void _useTemplate(BuildContext context, PromptTemplateEntity template) {
    try {
      final chatController = Get.find<ChatController>();
      chatController.applyTemplate(template.prompt);
      Get.back();
    } catch (_) {
      Get.back();
    }
  }

  void _showAddDialog(
      BuildContext context, PromptTemplateController controller) {
    final nameCtrl = TextEditingController();
    final promptCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        title: const Text('New Template'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) =>
                      v == null || v.trim().length < 3
                          ? 'At least 3 characters'
                          : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: descCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Description (optional)'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: promptCtrl,
                  decoration: const InputDecoration(labelText: 'Prompt'),
                  maxLines: 4,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              await controller.saveTemplate(
                name: nameCtrl.text,
                prompt: promptCtrl.text,
                description: descCtrl.text.isNotEmpty ? descCtrl.text : null,
              );
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.titleMedium);
  }
}

class _TemplateCard extends StatelessWidget {
  final PromptTemplateEntity template;
  final PromptTemplateController controller;
  final VoidCallback onUse;

  const _TemplateCard({
    required this.template,
    required this.controller,
    required this.onUse,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: template.emoji != null
            ? Text(template.emoji!, style: const TextStyle(fontSize: 24))
            : CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: const Icon(Icons.text_snippet_outlined,
                    color: AppColors.primary, size: 18),
              ),
        title: Text(template.name, style: AppTextStyles.titleMedium),
        subtitle: template.description != null
            ? Text(template.description!,
                style: AppTextStyles.bodySmall, maxLines: 1)
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!template.isBuiltIn)
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: () => controller.deleteTemplate(template.id),
                color: AppColors.error,
              ),
            FilledButton.tonal(
              onPressed: onUse,
              style: FilledButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
              child: const Text('Use'),
            ),
          ],
        ),
      ),
    );
  }
}
