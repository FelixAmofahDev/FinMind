import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/utils/currency_formatter.dart';
import 'package:finmind/shared/dialogs/confirm_dialog.dart';
import 'package:finmind/shared/widgets/app_card.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../../domain/entities/product.dart';
import '../providers/products_provider.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  const ProductDetailPage({super.key});

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  String _productId = '';
  AsyncValue<Product> _state = const AsyncLoading();
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic> && args['productId'] is String) {
        _productId = args['productId'] as String;
      }
      _load();
    }
  }

  Future<void> _load() async {
    if (_productId.isEmpty) {
      setState(() => _state = AsyncError('Product not found.', StackTrace.current));
      return;
    }
    setState(() => _state = const AsyncLoading());
    try {
      final useCase = await ref.read(getProductUseCaseProvider.future);
      final product = await useCase(productId: _productId);
      if (mounted) {
        setState(() => _state = AsyncData<Product>(product));
      }
    } catch (error) {
      if (mounted) {
        setState(() => _state = AsyncError(error, StackTrace.current));
      }
    }
  }

  Future<void> _deactivate(Product product) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Deactivate product?',
      message: '${product.name} will be hidden from your catalogue. This can be reversed later.',
      confirmText: 'Deactivate',
      destructive: true,
    );
    if (!confirmed || !mounted) {
      return;
    }

    try {
      final useCase = await ref.read(deactivateProductUseCaseProvider.future);
      await useCase(productId: product.id);
      ref.read(productsControllerProvider.notifier).refreshProducts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deactivated.')),
        );
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = _state.asData?.value;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          product?.name ?? 'Product Details',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: product != null
            ? [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () async {
                    final updated = await Navigator.of(context).pushNamed(
                      AppRoutes.productEdit,
                      arguments: <String, dynamic>{'product': product},
                    );
                    if (updated == true && mounted) {
                      _load();
                    }
                  },
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: _state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Could not load product.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Retry',
                    onPressed: _load,
                    expanded: false,
                  ),
                ],
              ),
            ),
          ),
          data: (Product product) => _buildContent(context, product),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Product product) {
    final margin = product.sellingPrice - product.costPrice;
    final marginPct = product.costPrice > 0 ? (margin / product.costPrice) * 100 : 0.0;
    final unitLabel = product.unitOfMeasure.isNotEmpty ? ' ${product.unitOfMeasure}' : '';

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        if (product.isLowStock) ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Low stock — ${product.currentStockQty.toStringAsFixed(0)}$unitLabel remaining.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Hero Metric Card
        AppCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Selling Price',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (product.isActive ? AppColors.success : AppColors.textSecondary)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.isActive ? 'Active' : 'Inactive',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: product.isActive ? AppColors.success : AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                CurrencyFormatter.format(product.sellingPrice),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              const Divider(height: 24, thickness: 0.8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _HeroMiniMetric(
                    label: 'Stock Available',
                    value: '${product.currentStockQty.toStringAsFixed(0)}$unitLabel',
                  ),
                  _HeroMiniMetric(
                    label: 'Profit Margin',
                    value: '${marginPct.toStringAsFixed(0)}%',
                    valueColor: margin >= 0 ? AppColors.success : AppColors.danger,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text(
          'Financial breakdown',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
        ),
        const SizedBox(height: 10),

        // Clean Grid Layout for Financials
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: [
            _Metric(
              label: 'Cost Price',
              value: CurrencyFormatter.format(product.costPrice),
            ),
            _Metric(
              label: 'Last Purchased Cost',
              value: CurrencyFormatter.format(product.lastPurchasedCost),
            ),
            _Metric(
              label: 'Stock Value',
              value: CurrencyFormatter.format(product.stockValue),
            ),
            _Metric(
              label: 'Net Profit',
              value: CurrencyFormatter.format(margin),
            ),
          ],
        ),
        const SizedBox(height: 24),

        Text(
          'Specifications',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
        ),
        const SizedBox(height: 10),

        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Column(
            children: [
              _DetailRow(label: 'Unit of measure', value: product.unitOfMeasure.isEmpty ? '—' : product.unitOfMeasure),
              const Divider(height: 1, thickness: 0.5),
              _DetailRow(label: 'SKU Identifier', value: product.sku.isEmpty ? '—' : product.sku),
              const Divider(height: 1, thickness: 0.5),
              _DetailRow(
                label: 'Category',
                value: product.categoryId?.isEmpty ?? true ? 'Unassigned' : product.categoryId!,
              ),
              const Divider(height: 1, thickness: 0.5),
              _DetailRow(
                label: 'Minimum Stock Warning',
                value: '${product.minimumStockQty.toStringAsFixed(0)}$unitLabel',
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Action Suite
        PrimaryButton(
          label: 'Restock inventory',
          icon: const Icon(Icons.add_box_outlined, size: 20),
          backgroundColor: AppColors.primary,
          onPressed: () async {
            final restocked = await Navigator.of(context).pushNamed(
              AppRoutes.restock,
              arguments: <String, dynamic>{'product': product},
            );
            if (restocked == true && mounted) {
              await _load();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Restock recorded successfully.')),
              );
            }
          },
          expanded: true,
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => _deactivate(product),
          icon: const Icon(Icons.visibility_off_outlined, size: 18),
          label: const Text('Deactivate product catalog'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.danger,
            side: BorderSide(color: AppColors.danger.withValues(alpha: 0.3)),
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroMiniMetric extends StatelessWidget {
  const _HeroMiniMetric({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor ?? AppColors.textPrimary,
              ),
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
          ),
        ],
      ),
    );
  }
}