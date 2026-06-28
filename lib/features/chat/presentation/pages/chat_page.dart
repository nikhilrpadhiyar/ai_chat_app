import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../routes/app_routes.dart';
import '../../../conversation/domain/entities/conversation_entity.dart';
import '../controllers/chat_controller.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/message_bubble.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final conversation = Get.arguments as ConversationEntity?;
    final controller = Get.find<ChatController>();

    if (conversation != null) {
      // Only load if different conversation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadConversation(conversation.id);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  conversation?.title ?? 'New Chat',
                  style: AppTextStyles.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  conversation?.model ?? '',
                  style: AppTextStyles.labelSmall,
                ),
              ],
            )),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome_outlined),
            onPressed: () => Get.toNamed(AppRoutes.promptTemplates),
            tooltip: 'Prompt Templates',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptions(context, controller, conversation),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.messages.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.messages.isEmpty) {
                return _WelcomeView(
                  onTemplateTap: (prompt) {
                    controller.applyTemplate(prompt);
                  },
                );
              }

              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: controller.messages.length,
                itemBuilder: (_, i) {
                  final msg = controller.messages[i];
                  final isLastAssistant = i == controller.messages.length - 1 &&
                      msg.isAssistant;
                  return MessageBubble(
                    message: msg,
                    isStreaming: isLastAssistant && controller.isStreaming.value,
                    streamingContent: controller.streamingContent.value,
                  );
                },
              );
            }),
          ),
          Obx(() {
            final err = controller.errorMessage.value;
            if (err == null) return const SizedBox.shrink();
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.error, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(err,
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.error))),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    color: AppColors.error,
                    onPressed: controller.clearError,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            );
          }),
          const ChatInputBar(),
        ],
      ),
    );
  }

  void _showOptions(
    BuildContext context,
    ChatController controller,
    ConversationEntity? conversation,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_sweep_outlined),
              title: const Text('Clear Messages'),
              onTap: () {
                Get.back();
                if (conversation != null) {
                  controller.messages.clear();
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.settings);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  final void Function(String prompt) onTemplateTap;

  const _WelcomeView({required this.onTemplateTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child:
                const Icon(Icons.auto_awesome, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text('Ask me anything',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text(
            'Start a conversation or pick a template below',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _QuickChip(
                emoji: '🔍',
                label: 'Code Review',
                onTap: () => onTemplateTap(
                    'Please review the following code for bugs and improvements:\n\n'),
              ),
              _QuickChip(
                emoji: '✍️',
                label: 'Writing Help',
                onTap: () => onTemplateTap(
                    'Please help me write or improve the following:\n\n'),
              ),
              _QuickChip(
                emoji: '💡',
                label: 'Brainstorm',
                onTap: () =>
                    onTemplateTap('Help me brainstorm ideas about:\n\n'),
              ),
              _QuickChip(
                emoji: '🐛',
                label: 'Debug',
                onTap: () => onTemplateTap(
                    'I\'m encountering this bug. Help me fix it:\n\nError:\n\nCode:\n\n'),
              ),
              _QuickChip(
                emoji: '📋',
                label: 'Summarize',
                onTap: () => onTemplateTap(
                    'Please summarize the following:\n\n'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;

  const _QuickChip({
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Text(emoji),
      label: Text(label),
      onPressed: onTap,
    );
  }
}
