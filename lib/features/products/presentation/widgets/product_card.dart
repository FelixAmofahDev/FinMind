import 'package:flutter/material.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';

import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Determine the stock text or pill layout based on low stock status
    final String formattedPrice = product.sellingPrice % 1 == 0 
        ? product.sellingPrice.toStringAsFixed(0) 
        : product.sellingPrice.toStringAsFixed(2);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            // Left Blue Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FF), // Light blue background
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFF1E60AA), // Darker blue icon color
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            
            // Middle Content Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title: Combine name and unit of measure safely
                  Text(
                    product.unitOfMeasure.isNotEmpty 
                        ? '${product.name} ${product.unitOfMeasure}' 
                        : product.name,
                    style: AppTextStyles.titleLarge.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A202C),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Stock Status and Pricing Row
                  Row(
                    children: [
                      if (product.isLowStock) ...[
                        // Orange/Red warning pill for low stock
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF2E9),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            '${product.openingQty.toStringAsFixed(0)} left',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 12,
                              color: const Color(0xFFB45309),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ] else ...[
                        // Default "in stock" text
                        Text(
                          '${product.openingQty.toStringAsFixed(0)} in stock',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      
                      // Intersecting separator and sales pricing text
                      Text(
                        ' · sells GHS $formattedPrice',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Right Chevron Arrow Action
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }}