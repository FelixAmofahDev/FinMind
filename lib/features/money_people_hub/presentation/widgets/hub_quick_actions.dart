import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

/// Prominent quick-action buttons on the hub for logging money movements.
class HubQuickActions extends StatelessWidget {
  const HubQuickActions({
    super.key,
    required this.onExpense,
    required this.onDeposit,
    required this.onWithdrawal,
  });

  final VoidCallback onExpense;
  final VoidCallback onDeposit;
  final VoidCallback onWithdrawal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickAction(
            icon: Icons.receipt_long_outlined,
            label: 'Expense',
            background: AppColors.coralLight,
            foreground: AppColors.coralDark,
            onTap: onExpense,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: _QuickAction(
            icon: Icons.south_west_rounded,
            label: 'Deposit',
            background: AppColors.tealLight,
            foreground: AppColors.tealDark,
            onTap: onDeposit,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: _QuickAction(
            icon: Icons.north_east_rounded,
            label: 'Withdraw',
            background: AppColors.purpleLight,
            foreground: AppColors.purpleDark,
            onTap: onWithdrawal,
          ),
        ),
      ],
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 21, color: foreground),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.inkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
