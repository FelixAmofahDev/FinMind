import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/product.dart';
import '../providers/products_provider.dart';
import '../widgets/product_edit_form_card.dart';

class ProductEditPage extends ConsumerWidget {
  const ProductEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final product = args is Map<String, dynamic> ? args['product'] as Product? : null;

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit product')),
        body: const Center(child: Text('Product not found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ProductEditFormCard(
              product: product,
              onSubmit: ({
                required String name,
                required double sellingPrice,
                required double costPrice,
                required double minimumStockQty,
                required String unitOfMeasure,
                String? sku,
                String? categoryId,
              }) async {
                final updated = await ref.read(productsControllerProvider.notifier).updateProduct(
                      productId: product.id,
                      name: name,
                      sellingPrice: sellingPrice,
                      costPrice: costPrice,
                      minimumStockQty: minimumStockQty,
                      unitOfMeasure: unitOfMeasure,
                      sku: sku,
                      categoryId: categoryId,
                    );
                if (updated != null && context.mounted) {
                  Navigator.of(context).pop(true);
                }
                return updated;
              },
            ),
          ],
        ),
      ),
    );
  }
}
