import 'package:flutter/material.dart';

import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/shared/widgets/empty_state_widget.dart';
import 'package:finmind/shared/widgets/loading_indicator.dart';

import '../../domain/entities/product.dart';
import 'product_card.dart';

class ProductsCatalogSection extends StatelessWidget {
  const ProductsCatalogSection({
    super.key,
    required this.products,
    required this.isLoading,
    required this.onboardingFlow,
    this.onDeactivate,
  });

  final List<Product> products;
  final bool isLoading;
  final bool onboardingFlow;
  final Future<void> Function(Product product)? onDeactivate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'Products',
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '${products.length} total',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (isLoading && products.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: LoadingIndicator(message: 'Loading products...'),
          )
        else if (products.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: EmptyStateWidget(
              title: onboardingFlow ? 'No products yet' : 'Catalogue is empty',
              message: onboardingFlow
                  ? 'Add at least one product to continue onboarding.'
                  : 'Use the form above to build your product catalogue.',
              icon: Icons.inventory_2_outlined,
            ),
          )
        else
          ...products.map(
            (product) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ProductCard(
                product: product,
                onDeactivate: onDeactivate == null ? null : () => onDeactivate!(product),
              ),
            ),
          ),
      ],
    );
  }
}
