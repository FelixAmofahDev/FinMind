import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';

import '../../domain/entities/product.dart';
import '../providers/products_provider.dart';
import '../widgets/products_catalog_section.dart';
import '../widgets/products_header_card.dart';
import '../widgets/products_onboarding_footer.dart';
import '../widgets/products_search_bar.dart';

class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key, this.onboardingFlow = false});

  final bool onboardingFlow;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productsControllerProvider);
    final products = productsState.value ?? <Product>[];
    final controller = ref.read(productsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(onboardingFlow ? 'Set up products' : 'Products'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: controller.refreshProducts,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pushNamed(
          AppRoutes.productCreate,
          arguments: <String, dynamic>{'onboardingFlow': onboardingFlow},
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add product'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshProducts,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ProductsHeaderCard(
                onboardingFlow: onboardingFlow,
                productCount: products.length,
              ),
              const SizedBox(height: 18),
              const ProductsSearchBar(),
              const SizedBox(height: 18),
              ProductsCatalogSection(
                products: products,
                isLoading: productsState.isLoading,
                onboardingFlow: onboardingFlow,
                onTap: (product) => Navigator.of(context).pushNamed(
                  AppRoutes.productDetail,
                  arguments: <String, dynamic>{'productId': product.id},
                ),
                onAdd: () => Navigator.of(context).pushNamed(
                  AppRoutes.productCreate,
                  arguments: <String, dynamic>{'onboardingFlow': onboardingFlow},
                ),
              ),
              if (onboardingFlow)
                ProductsOnboardingFooter(
                  canContinue: products.isNotEmpty,
                  onContinue: () => Navigator.of(context).pushNamed(AppRoutes.onboardingComplete),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
