import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';

import '../../domain/entities/product_input.dart';
import '../providers/products_provider.dart';
import '../widgets/product_form_card.dart';

class ProductFormPage extends ConsumerWidget {
  const ProductFormPage({super.key, this.onboardingFlow = false});

  final bool onboardingFlow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add product'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextButton.icon(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.productBulkImport,
              ),
              icon: const Icon(Icons.upload_file_rounded),
              label: const Text('Bulk import products'),
            ),
            const SizedBox(height: 12),
            ProductFormCard(
              onSubmit: (ProductInput input) async {
                final created = await ref
                    .read(productsControllerProvider.notifier)
                    .addProduct(input: input);
                if (created != null && context.mounted) {
                  Navigator.of(context).pop();
                }
                return created;
              },
            ),
          ],
        ),
      ),
    );
  }
}
