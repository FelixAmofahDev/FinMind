import 'package:flutter/material.dart';

import 'markdown_renderer.dart';
import 'streaming_text.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.role,
    required this.content,
    this.timestamp,
    this.onRetry,
    this.animate = false,
  });

  final String role;
  final String content;
  final DateTime? timestamp;
  final VoidCallback? onRetry;

  /// Only true for a message that was just received from the assistant
  /// in this session — historical/loaded messages should render instantly.
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = role == 'user';

    return isUser ? _buildUserBubble(context, theme) : _buildAssistantText(context, theme);
  }

  Widget _buildUserBubble(BuildContext context, ThemeData theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.78,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(
              content,
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 18,
                height: 1.5,
              ),
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
        ],
      ),
    );
  }

  Widget _buildAssistantText(BuildContext context, ThemeData theme) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: 18,
              height: 1.6,
              color: theme.colorScheme.onSurface,
            ),
            child: StreamingText(
              content: content,
              textColor: theme.colorScheme.onSurface,
              headingColor: theme.colorScheme.primary,
              linkColor: theme.colorScheme.primary,
              animate: animate && content.isNotEmpty,
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
          if (onRetry != null && content.isEmpty) ...[
            const SizedBox(height: 4),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 14),
              label: const Text('Retry'),
              style: TextButton.styleFrom(
                textStyle: theme.textTheme.bodySmall,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final isToday = now.year == time.year && now.month == time.month && now.day == time.day;
    if (isToday) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = yesterday.year == time.year && yesterday.month == time.month && yesterday.day == time.day;
    if (isYesterday) {
      return 'Yesterday ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '${time.day}/${time.month}/${time.year}';
  }
}