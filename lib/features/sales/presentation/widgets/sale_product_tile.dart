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
    final isOutOfStock = stock <= 0;
    final isLowStock = product.isLowStock && !isOutOfStock;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Image / placeholder area — flexible, not fixed height ──
          Expanded(
            flex: 6,
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.06),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.inventory_2_outlined,
                        size: 30,
                        color: AppColors.primary.withOpacity(0.35),
                      ),
                    ),
                  ),
                ),
                if (isOutOfStock)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(14),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _StockBadge(
                    isOutOfStock: isOutOfStock,
                    isLowStock: isLowStock,
                    stock: stock,
                  ),
                ),
              ],
            ),
          ),

          // ── Text + button area — sized to content, never overflows ──
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    'GHS $formattedPrice',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.primary,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton.icon(
                      onPressed: isOutOfStock ? null : onAddToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            AppColors.textSecondary.withOpacity(0.15),
                        disabledForegroundColor: AppColors.textSecondary,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      icon: Icon(
                        isOutOfStock
                            ? Icons.block_rounded
                            : Icons.add_shopping_cart_rounded,
                        size: 14,
                      ),
                      label: Text(isOutOfStock ? 'Out of stock' : 'Add to cart'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({
    required this.isOutOfStock,
    required this.isLowStock,
    required this.stock,
  });

  final bool isOutOfStock;
  final bool isLowStock;
  final int stock;

  @override
  Widget build(BuildContext context) {
    if (!isOutOfStock && !isLowStock) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.coralDark,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        isOutOfStock ? 'Out of stock' : '$stock left',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          height: 1,
        ),
      ),
    );
  }
}