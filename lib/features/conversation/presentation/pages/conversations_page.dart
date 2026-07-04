import 'package:ai_chat_app/core/theme/app_colors.dart';
import 'package:ai_chat_app/core/theme/app_text_styles.dart';
import 'package:ai_chat_app/core/utils/extensions.dart';
import 'package:ai_chat_app/features/conversation/domain/entities/conversation_entity.dart';
import 'package:ai_chat_app/features/conversation/presentation/controllers/conversation_controller.dart';
import 'package:ai_chat_app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ConversationController controller =
        Get.find<ConversationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.conversations.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.conversations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No conversations yet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Start a new chat to begin',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadConversations,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.conversations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, int i) {
              final ConversationEntity conv = controller.conversations[i];
              return Dismissible(
                key: Key(conv.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_rounded, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  return await Get.dialog<bool>(
                        AlertDialog(
                          title: const Text('Delete conversation?'),
                          content: const Text(
                            'This will permanently delete this conversation and all its messages.',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Get.back(result: false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Get.back(result: true),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.error,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      ) ??
                      false;
                },
                onDismissed: (_) => controller.deleteConversation(conv.id),
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.chat_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    title: Text(
                      conv.title,
                      style: AppTextStyles.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: conv.lastMessage != null
                        ? Text(
                            conv.lastMessage!,
                            style: AppTextStyles.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    trailing: Text(
                      conv.updatedAt.timeLabel,
                      style: AppTextStyles.labelSmall,
                    ),
                    onTap: () => controller.openConversation(conv),
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final ConversationEntity? conv = await controller
              .createNewConversation();
          if (conv != null) {
            Get.toNamed(AppRoutes.chat, arguments: conv);
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New Chat'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
