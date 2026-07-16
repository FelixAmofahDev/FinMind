
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/features/debtors/domain/entities/debtor.dart';
import 'package:finmind/shared/extensions/num_extensions.dart';
import 'package:finmind/shared/widgets/app_card.dart';
import 'package:flutter/material.dart';


class DebtorHeader extends StatelessWidget {
  const DebtorHeader({super.key, required this.debtor});

  final Debtor debtor;

  @override
  Widget build(BuildContext context) {
    final initial = debtor.name.trim().isNotEmpty
        ? debtor.name.trim()[0].toUpperCase()
        : '?';
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.amberLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              initial,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.amberDark,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  debtor.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'Owes ',
                      style: TextStyle(fontSize: 12.5, color: AppColors.mute),
                    ),
                    Text(
                      debtor.amountOutstanding.toCurrency(),
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coralDark,
                      ),
                    ),
                    if (debtor.isOverdue)
                      const Text(
                        ' · overdue',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.coralDark,
                        ),
                      ),
                  ],
                ),
                if (debtor.phone.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    debtor.phone,
                    style: TextStyle(fontSize: 12, color: AppColors.mute),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }}