import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/extensions/datetime_extensions.dart';
import '../../../../shared/extensions/num_extensions.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';

class ExpenseListTile extends StatelessWidget {
  const ExpenseListTile({
    super.key,
    required this.expense,
    this.showDivider = true,
  });

  final Expense expense;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final title = expense.paidTo.isNotEmpty
        ? expense.paidTo
        : expense.category.label;
    final subtitleParts = <String>[
      expense.category.label,
      expense.paymentMethod.label,
      if (expense.createdAt != null) expense.createdAt!.formatDate(),
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
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
                child: Icon(
                  _iconFor(expense.category),
                  size: 18,
                  color: AppColors.coralDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitleParts.join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mute,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '- ${expense.amount.toCurrency()}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coralDark,
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: AppColors.line),
      ],
    );
  }

  IconData _iconFor(ExpenseCategory category) {
    return switch (category) {
      ExpenseCategory.transport => Icons.directions_bus_outlined,
      ExpenseCategory.rent => Icons.home_work_outlined,
      ExpenseCategory.wages => Icons.groups_outlined,
      ExpenseCategory.utilities => Icons.bolt_outlined,
      ExpenseCategory.packaging => Icons.inventory_2_outlined,
      ExpenseCategory.other => Icons.receipt_long_outlined,
    };
  }
}
