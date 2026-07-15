import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/extensions/num_extensions.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../domain/entities/debtor.dart';

/// A single debtor row used inside the debtors list.
class DebtorListTile extends StatelessWidget {
  const DebtorListTile({
    super.key,
    required this.debtor,
    required this.onTap,
    this.showDivider = true,
  });

  final Debtor debtor;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final initial = debtor.name.trim().isNotEmpty
        ? debtor.name.trim()[0].toUpperCase()
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
                    color: AppColors.amberLight,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.amberDark,
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
                        debtor.name,
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
                  debtor.amountOutstanding.toCurrency(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
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
    if (debtor.isOverdue) {
      return StatusPill(
        label: debtor.daysOverdue > 0
            ? 'Overdue ${debtor.daysOverdue}d'
            : 'Overdue',
        tone: StatusPillTone.overdue,
      );
    }
    if (debtor.isDueSoon) {
      return const StatusPill(label: 'Due soon', tone: StatusPillTone.dueSoon);
    }
    return Text(
      debtor.hasDueDate ? 'Due ${_formatDate(debtor.dueDate!)}' : 'No due date',
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
