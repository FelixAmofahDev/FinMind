import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/shared/widgets/loading_indicator.dart';
import 'package:finmind/shared/widgets/empty_state_widget.dart';

import '../../../../features/audit_trail/presentation/providers/audit_trail_provider.dart';

class ActivityListCard extends ConsumerStatefulWidget {
  const ActivityListCard({super.key});

  @override
  ConsumerState<ActivityListCard> createState() => _ActivityListCardState();
}

class _ActivityListCardState extends ConsumerState<ActivityListCard> {
  bool _didLoad = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_didLoad && mounted) {
        _didLoad = true;
        ref.read(auditLogsControllerProvider.notifier).loadFirstPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auditState = ref.watch(auditLogsControllerProvider);
    final logs = auditState.logs;
    final items = logs.take(10).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7EBF0)),
      ),
      child: Column(
        children: [
          if (auditState.isLoading && items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: LoadingIndicator(message: 'Loading activity...'),
            )
          else if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: EmptyStateWidget(
                icon: Icons.history_outlined,
                title: 'No recent activity',
                message: 'Accounting and operational actions will appear here.',
              ),
            )
          else
            Column(
              children: List.generate(items.length, (i) {
                final isLast = i == items.length - 1;
                final log = items[i];
                return Container(
                  decoration: BoxDecoration(
                    border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFE7EBF0))),
                  ),
                  child: _ActivityRow(
                    title: log.summary,
                    subtitle: _formatDate(log.createdAt),
                    entity: log.entity,
                    action: log.action,
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) {
      return 'Today, ${_formatTime(date)}';
    } else if (diff.inDays == 1) {
      return 'Yesterday, ${_formatTime(date)}';
    } else {
      return '${date.day} ${_monthShort(date)} ${date.year}, ${_formatTime(date)}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final displayHour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    return '$displayHour:$minute $period';
  }

  String _monthShort(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[date.month - 1];
  }
}

class _ActivityRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String entity;
  final String action;

  const _ActivityRow({
    required this.title,
    required this.subtitle,
    required this.entity,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final entityColor = _entityColor(entity);
    final actionColor = _actionColor(action);

    return Container(
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(
      color: Colors.grey.withOpacity(0.10),
    ),
  ),
  child: Row(
    children: [
      // Entity icon
      Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: entityColor.withOpacity(0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          _entityIcon(entity),
          size: 19,
          color: entityColor,
        ),
      ),

      const SizedBox(width: 12),

      // Title + subtitle
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),

      const SizedBox(width: 10),

      // Action
      Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: actionColor.withOpacity(0.09),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: actionColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              action,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: actionColor,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
);
  }

  Color _entityColor(String entity) {
    switch (entity) {
      case 'sale':
        return AppColors.teal;
      case 'stock_purchase':
        return AppColors.amber;
      case 'expense':
        return AppColors.coral;
      case 'debtor_payment':
        return AppColors.blue;
      case 'creditor_payment':
        return AppColors.purple;
      case 'owner_deposit':
        return AppColors.tealDark;
      case 'owner_withdrawal':
        return AppColors.coralDark;
      default:
        return AppColors.mute;
    }
  }

  Color _actionColor(String action) {
    switch (action) {
      case 'created':
        return AppColors.success;
      case 'updated':
        return AppColors.blue;
      case 'voided':
        return AppColors.warning;
      case 'deleted':
        return AppColors.danger;
      default:
        return AppColors.mute;
    }
  }

  IconData _entityIcon(String entity) {
    switch (entity) {
      case 'sale':
        return Icons.point_of_sale_rounded;
      case 'stock_purchase':
        return Icons.shopping_cart_rounded;
      case 'expense':
        return Icons.receipt_long_rounded;
      case 'debtor_payment':
        return Icons.payments_rounded;
      case 'creditor_payment':
        return Icons.account_balance_wallet_rounded;
      case 'owner_deposit':
        return Icons.savings_rounded;
      case 'owner_withdrawal':
        return Icons.account_balance_rounded;
      default:
        return Icons.history_rounded;
    }
  }
}
