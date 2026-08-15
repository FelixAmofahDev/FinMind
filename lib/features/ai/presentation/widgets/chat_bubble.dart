import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import 'markdown_renderer.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.role,
    required this.content,
    this.timestamp,
    this.onRetry,
  });

  final String role;
  final String content;
  final DateTime? timestamp;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = role == 'user';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser) ...[
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.blue,
            ),
            child: const Icon(Icons.smart_toy_rounded, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 320),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isUser
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isUser ? 16 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 16),
                  ),
                  border: isUser
                      ? null
                      : Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: isUser
                    ? Text(
                        content,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      )
                    : MarkdownRenderer(
                        content: content,
                        textColor: theme.colorScheme.onSurface,
                        headingColor: theme.colorScheme.primary,
                        linkColor: theme.colorScheme.primary,
                      ),
              ),
              if (timestamp != null) ...[
                const SizedBox(height: 4),
                Text(
                  _formatTime(timestamp!),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
              if (onRetry != null && !isUser && content.isEmpty) ...[
                const SizedBox(height: 4),
                TextButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 14),
                  label: const Text('Retry'),
                  style: TextButton.styleFrom(
                    textStyle: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (isUser) ...[
          const SizedBox(width: 8),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primaryContainer,
            ),
            child: Icon(Icons.person_rounded, size: 18,
                color: theme.colorScheme.onPrimaryContainer),
          ),
        ],
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final isToday = now.year == time.year &&
        now.month == time.month &&
        now.day == time.day;
    if (isToday) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = yesterday.year == time.year &&
        yesterday.month == time.month &&
        yesterday.day == time.day;
    if (isYesterday) {
      return 'Yesterday ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '${time.day}/${time.month}/${time.year}';
  }
}
