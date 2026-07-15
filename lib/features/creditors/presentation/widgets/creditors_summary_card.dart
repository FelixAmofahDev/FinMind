import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/extensions/num_extensions.dart';

/// Hero card summarising total money the business owes suppliers.
class CreditorsSummaryCard extends StatelessWidget {
  const CreditorsSummaryCard({
    super.key,
    required this.totalOutstanding,
    required this.totalCreditorsCount,
    required this.overdueCount,
  });

  final double totalOutstanding;
  final int totalCreditorsCount;
  final int overdueCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(19, 17, 19, 17),
      decoration: BoxDecoration(
        color: AppColors.coralDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total you owe',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFFF3D3C7),
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
                '$totalCreditorsCount ${totalCreditorsCount == 1 ? 'supplier' : 'suppliers'}',
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFFF3D3C7),
                ),
              ),
              if (overdueCount > 0) ...[
                const Text(
                  ' · ',
                  style: TextStyle(fontSize: 12.5, color: Color(0xFFF3D3C7)),
                ),
                Text(
                  '$overdueCount overdue',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFFE0B2),
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
