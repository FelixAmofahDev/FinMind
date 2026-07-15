import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

enum StatusPillTone { overdue, dueSoon, ok, neutral }

/// A small rounded pill for statuses (overdue / due soon / paid) matching the
/// prototype `.pill` component.
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.tone = StatusPillTone.neutral,
    this.icon,
  });

  final String label;
  final StatusPillTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final (Color background, Color foreground) = switch (tone) {
      StatusPillTone.overdue => (AppColors.coralLight, AppColors.coralDark),
      StatusPillTone.dueSoon => (AppColors.amberLight, AppColors.amberDark),
      StatusPillTone.ok => (AppColors.tealLight, AppColors.tealDark),
      StatusPillTone.neutral => (AppColors.line, AppColors.inkSoft),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}
