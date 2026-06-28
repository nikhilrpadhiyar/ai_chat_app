import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../controllers/chat_controller.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.fromLTRB(
          12, 8, 12, MediaQuery.of(context).viewInsets.bottom + 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Obx(() => IconButton(
                icon: Icon(
                  controller.isListening.value ? Icons.mic : Icons.mic_none,
                  color: controller.isListening.value
                      ? AppColors.error
                      : AppColors.textSecondary,
                ),
                onPressed: controller.isListening.value
                    ? controller.stopVoiceInput
                    : controller.startVoiceInput,
              )),
          Expanded(
            child: TextField(
              controller: controller.textController,
              maxLines: 5,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Message Claude...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor:
                    isDark ? AppColors.darkInputFill : AppColors.inputFill,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
              onSubmitted: (_) => controller.sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Obx(() => controller.isStreaming.value
              ? IconButton(
                  icon: const Icon(Icons.stop_circle_outlined,
                      color: AppColors.error),
                  onPressed: () {
                    // Cancel is handled via streamSub in controller
                  },
                )
              : IconButton.filled(
                  icon: const Icon(Icons.send_rounded, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: controller.sendMessage,
                )),
        ],
      ),
    );
  }
}
