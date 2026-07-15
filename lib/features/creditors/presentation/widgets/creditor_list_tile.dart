import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/extensions/num_extensions.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../domain/entities/creditor.dart';

/// A single creditor (supplier) row used inside the creditors list.
class CreditorListTile extends StatelessWidget {
  const CreditorListTile({
    super.key,
    required this.creditor,
    required this.onTap,
    this.showDivider = true,
  });

  final Creditor creditor;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final initial = creditor.name.trim().isNotEmpty
        ? creditor.name.trim()[0].toUpperCase()
        : '?';

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.coralLight,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.coralDark,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        creditor.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 3),
                      _buildStatus(context),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  creditor.amountOutstanding.toCurrency(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coralDark,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: AppColors.mute,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: AppColors.line),
      ],
    );
  }

  Widget _buildStatus(BuildContext context) {
    if (creditor.isOverdue) {
      return StatusPill(
        label: creditor.daysOverdue > 0
            ? 'Overdue ${creditor.daysOverdue}d'
            : 'Overdue',
        tone: StatusPillTone.overdue,
      );
    }
    if (creditor.isDueSoon) {
      return const StatusPill(label: 'Due soon', tone: StatusPillTone.dueSoon);
    }
    return Text(
      creditor.hasDueDate
          ? 'Due ${_formatDate(creditor.dueDate!)}'
          : 'No due date',
      style: const TextStyle(fontSize: 12, color: AppColors.mute),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}
