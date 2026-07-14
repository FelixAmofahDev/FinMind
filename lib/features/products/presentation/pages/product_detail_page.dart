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
      message:
          '${product.name} will be hidden from your catalogue. This can be reversed later.',
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
      appBar: AppBar(
        title: Text(product?.name ?? 'Product'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: AppColors.background,
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
    final marginPct = product.costPrice > 0
        ? (margin / product.costPrice) * 100
        : 0.0;
    final unitLabel = product.unitOfMeasure.isNotEmpty ? ' ${product.unitOfMeasure}' : '';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (product.isLowStock)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                const SizedBox(width: 10),
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
        Row(
          children: [
            Expanded(
              child: _Metric(
                label: 'Selling price',
                value: CurrencyFormatter.format(product.sellingPrice),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Metric(
                label: 'Cost price',
                value: CurrencyFormatter.format(product.costPrice),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _Metric(
                label: 'In stock',
                value: '${product.currentStockQty.toStringAsFixed(0)} x$unitLabel',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Metric(
                label: 'Profit Margin',
                value:
                    '${CurrencyFormatter.format(margin)} (${marginPct.toStringAsFixed(0)}%)',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _Metric(
                label: 'Minimum stock',
                value: product.minimumStockQty.toStringAsFixed(0),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _Metric(
                label: 'Stock value',
                value: CurrencyFormatter.format(product.stockValue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            children: [
              _DetailRow(label: 'Unit of measure', value: product.unitOfMeasure),
              _DetailRow(label: 'SKU', value: product.sku.isEmpty ? '—' : product.sku),
              _DetailRow(
                label: 'Category',
                value: product.categoryId?.isEmpty ?? true ? '—' : product.categoryId!,
              ),
              _DetailRow(
                label: 'Status',
                value: product.isActive ? 'Active' : 'Inactive',
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          label: 'Update product',
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
          expanded: true,
        ),
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Restock product',
          icon: const Icon(Icons.add_box_outlined),
          backgroundColor: AppColors.secondary,
          onPressed: () async {
            final restocked = await Navigator.of(context).pushNamed(
              AppRoutes.restock,
              arguments: <String, dynamic>{'product': product},
            );
            if (restocked == true && mounted) {
              _load();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Restock recorded.')),
              );
            }
          },
          expanded: true,
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _deactivate(product),
          icon: const Icon(Icons.delete_outline, color: AppColors.danger),
          label: const Text('Deactivate product'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.danger,
            side: BorderSide(color: AppColors.danger.withValues(alpha: 0.5)),
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

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
