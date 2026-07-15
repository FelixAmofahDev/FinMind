import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/extensions/datetime_extensions.dart';
import '../../../../shared/extensions/num_extensions.dart';
import '../../domain/entities/owner_transaction.dart';
import '../../domain/entities/owner_transaction_type.dart';

class OwnerTransactionListTile extends StatelessWidget {
  const OwnerTransactionListTile({
    super.key,
    required this.transaction,
    this.showDivider = true,
  });

  final OwnerTransaction transaction;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final isDeposit = transaction.type == OwnerTransactionType.deposit;
    final accent = isDeposit ? AppColors.tealDark : AppColors.purpleDark;
    final accentLight = isDeposit ? AppColors.tealLight : AppColors.purpleLight;

    final subtitleParts = <String>[
      transaction.paymentMethod.label,
      if (transaction.createdAt != null) transaction.createdAt!.formatDate(),
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
                  color: accentLight,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  isDeposit
                      ? Icons.south_west_rounded
                      : Icons.north_east_rounded,
                  size: 18,
                  color: accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.notes.isNotEmpty
                          ? transaction.notes
                          : transaction.type.longLabel,
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
                '${isDeposit ? '+' : '-'} ${transaction.amount.toCurrency()}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: accent,
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
}
