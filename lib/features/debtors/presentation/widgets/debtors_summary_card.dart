import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/extensions/num_extensions.dart';

/// Blue hero card summarising total money owed to the business.
class DebtorsSummaryCard extends StatelessWidget {
  const DebtorsSummaryCard({
    super.key,
    required this.totalOutstanding,
    required this.totalDebtorsCount,
    required this.overdueCount,
  });

  final double totalOutstanding;
  final int totalDebtorsCount;
  final int overdueCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(19, 17, 19, 17),
      decoration: BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total owed to you',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFFB9D4EF),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            totalOutstanding.toCurrency(),
            style: const TextStyle(
              fontSize: 29,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                '$totalDebtorsCount ${totalDebtorsCount == 1 ? 'person' : 'people'}',
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFFCFE2F7),
                ),
              ),
              if (overdueCount > 0) ...[
                const Text(
                  ' · ',
                  style: TextStyle(fontSize: 12.5, color: Color(0xFFCFE2F7)),
                ),
                Text(
                  '$overdueCount overdue',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF3C969),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
