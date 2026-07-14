import 'package:flutter/material.dart';

import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/shared/widgets/app_card.dart';

import '../../domain/entities/product.dart';
import 'product_metric_chip.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onDeactivate,
  });

  final Product product;
  final VoidCallback? onDeactivate;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.unitOfMeasure,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: product.isActive ? AppColors.success.withValues(alpha: 0.12) : AppColors.border,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  product.isActive ? 'Active' : 'Inactive',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: product.isActive ? AppColors.success : AppColors.textSecondary,
                  ),
                ),
              ),
              if (onDeactivate != null)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'deactivate') {
                      onDeactivate?.call();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem<String>(
                      value: 'deactivate',
                      child: Text('Deactivate'),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ProductMetricChip(label: 'Selling', value: 'GH₵ ${product.sellingPrice.toStringAsFixed(2)}'),
              ProductMetricChip(label: 'Cost', value: 'GH₵ ${product.costPrice.toStringAsFixed(2)}'),
              ProductMetricChip(label: 'Opening qty', value: product.openingQty.toStringAsFixed(0)),
              ProductMetricChip(label: 'Min stock', value: product.minimumStockQty.toStringAsFixed(0)),
              ProductMetricChip(label: 'Stock value', value: 'GH₵ ${product.stockValue.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    );
  }
}
