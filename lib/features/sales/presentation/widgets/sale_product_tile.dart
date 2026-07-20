import 'package:finmind/core/theme/colors.dart';
import 'package:flutter/material.dart';

import '../../../../features/products/domain/entities/product.dart';
import '../../../../shared/widgets/app_card.dart';

class CartItem {
   CartItem({required this.product, this.quantity = 1});

  final Product product;
  int quantity;
}

class SaleProductTile extends StatelessWidget {
  const SaleProductTile({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  final Product product;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final formattedPrice = product.sellingPrice % 1 == 0
        ? product.sellingPrice.toStringAsFixed(0)
        : product.sellingPrice.toStringAsFixed(2);

    final stock = product.currentStockQty.toInt();
    final isLowStock = product.isLowStock || stock <= 0;

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'GHS $formattedPrice',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isLowStock ? '$stock left' : '$stock in stock',
                  style: TextStyle(
                    fontSize: 12,
                    color: isLowStock ? AppColors.coralDark : AppColors.textSecondary,
                    fontWeight: isLowStock ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLowStock ? null : onAddToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text(isLowStock ? 'Out of stock' : 'Add to cart'),
            ),
          ),
        ],
      ),
    );
  }
}
