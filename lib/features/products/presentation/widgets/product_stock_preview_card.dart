import 'package:flutter/material.dart';

import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';

class ProductStockPreviewCard extends StatelessWidget {
  const ProductStockPreviewCard({
    super.key,
    required this.costPrice,
    required this.openingQty,
  });

  final String costPrice;
  final String openingQty;

  @override
  Widget build(BuildContext context) {
    final parsedCost = double.tryParse(costPrice.trim()) ?? 0;
    final parsedQty = double.tryParse(openingQty.trim()) ?? 0;
    final stockValue = parsedCost * parsedQty;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet_outlined, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Opening stock value preview',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            'GH₵ ${stockValue.toStringAsFixed(2)}',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
