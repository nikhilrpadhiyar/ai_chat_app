import 'package:ai_chat_app/core/theme/app_colors.dart';
import 'package:ai_chat_app/core/theme/app_text_styles.dart';
import 'package:ai_chat_app/core/utils/extensions.dart';
import 'package:ai_chat_app/features/chat/domain/entities/message_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.isStreaming = false,
    this.streamingContent = '',
  });
  final MessageEntity message;
  final bool isStreaming;
  final String streamingContent;

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.isUser;
    final bool isDark = context.isDark;
    final String content = isStreaming && message.isAssistant
        ? streamingContent
        : message.content;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.screenWidth * 0.85),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Column(
            crossAxisAlignment: isUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[
              _buildBubble(context, content, isUser, isDark),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    message.createdAt.timeOnly,
                    style: AppTextStyles.labelSmall,
                  ),
                  if (isStreaming && message.isAssistant) ...<Widget>[
                    const SizedBox(width: 4),
                    _TypingIndicator(),
                  ],
                  if (message.hasError) ...<Widget>[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.error_outline,
                      size: 12,
                      color: AppColors.error,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBubble(
    BuildContext context,
    String content,
    bool isUser,
    bool isDark,
  ) {
    return GestureDetector(
      onLongPress: () => _copyToClipboard(context, content),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser
              ? AppColors.userBubble
              : (isDark ? AppColors.aiBubble : AppColors.aiBubbleLight),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
        ),
        child: isUser
            ? Text(
                content,
                style: AppTextStyles.chatMessage.copyWith(color: Colors.white),
              )
            : MarkdownBody(
                data: content.isEmpty ? '...' : content,
                styleSheet: _markdownStyle(context, isDark),
                selectable: true,
              ),
      ),
    );
  }

  MarkdownStyleSheet _markdownStyle(BuildContext context, bool isDark) {
    final Color textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    return MarkdownStyleSheet(
      p: AppTextStyles.chatMessage.copyWith(color: textColor),
      h1: AppTextStyles.headlineMedium.copyWith(color: textColor),
      h2: AppTextStyles.titleLarge.copyWith(color: textColor),
      h3: AppTextStyles.titleMedium.copyWith(color: textColor),
      code: AppTextStyles.codeBlock.copyWith(
        color: isDark ? Colors.greenAccent : AppColors.primaryDark,
        backgroundColor: isDark
            ? const Color(0xFF2A2A45)
            : const Color(0xFFEEECFF),
      ),
      codeblockDecoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A35) : const Color(0xFFF0EEFF),
        borderRadius: BorderRadius.circular(8),
      ),
      blockquoteDecoration: BoxDecoration(
        border: Border(left: BorderSide(color: AppColors.primary, width: 3)),
      ),
      strong: AppTextStyles.chatMessage.copyWith(
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      em: AppTextStyles.chatMessage.copyWith(
        fontStyle: FontStyle.italic,
        color: textColor,
      ),
      listBullet: AppTextStyles.chatMessage.copyWith(color: textColor),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          3,
          (int i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.5),
            child: Transform.translate(
              offset: Offset(
                0,
                -3 *
                    (1 +
                        ((_controller.value + i * 0.3) % 1.0 < 0.5
                            ? (_controller.value + i * 0.3) % 1.0
                            : 1 - (_controller.value + i * 0.3) % 1.0)),
              ),
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
