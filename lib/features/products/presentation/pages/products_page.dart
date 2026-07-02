import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/shared/widgets/app_card.dart';
import 'package:finmind/shared/widgets/app_text_field.dart';
import 'package:finmind/shared/widgets/empty_state_widget.dart';
import 'package:finmind/shared/widgets/loading_indicator.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/product_input.dart';
import '../providers/products_provider.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key, this.onboardingFlow = false});

  final bool onboardingFlow;

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _sellingPriceController;
  late final TextEditingController _costPriceController;
  late final TextEditingController _openingQtyController;
  late final TextEditingController _minimumStockQtyController;
  late final TextEditingController _unitController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _sellingPriceController = TextEditingController();
    _costPriceController = TextEditingController();
    _openingQtyController = TextEditingController();
    _minimumStockQtyController = TextEditingController();
    _unitController = TextEditingController(text: 'piece');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sellingPriceController.dispose();
    _costPriceController.dispose();
    _openingQtyController.dispose();
    _minimumStockQtyController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsControllerProvider);
    final products = productsState.value ?? <Product>[];
    final isSubmitting = productsState.isLoading && products.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.onboardingFlow ? 'Set up products' : 'Products'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => ref.read(productsControllerProvider.notifier).refreshProducts(),
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              _HeaderCard(onboardingFlow: widget.onboardingFlow, productCount: products.length),
              const SizedBox(height: 18),
              Form(
                key: _formKey,
                child: AppCard(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                       PrimaryButton(
                  label: 'Continue to onboarding',
                  onPressed: products.isEmpty ? null : _continueToOnboarding,
                  expanded: true,
                ),
                const SizedBox(height: 8),
                      Text(
                        'Add product',
                        style: AppTextStyles.titleLarge.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Capture the opening stock so the system can track inventory and pricing correctly.',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _nameController,
                        labelText: 'Product name',
                        hintText: 'e.g. Cowbell Milk Powder 400g',
                        textInputAction: TextInputAction.next,
                        validator: (value) => (value ?? '').trim().isEmpty ? 'Product name is required' : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _sellingPriceController,
                              labelText: 'Selling price',
                              hintText: '0.00',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: _amountValidator,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _costPriceController,
                              labelText: 'Cost price',
                              hintText: '0.00',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: _amountValidator,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: _openingQtyController,
                              labelText: 'Opening quantity',
                              hintText: '0',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: _amountValidator,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppTextField(
                              controller: _minimumStockQtyController,
                              labelText: 'Minimum stock',
                              hintText: '0',
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              validator: _amountValidator,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _unitController,
                        labelText: 'Unit of measure',
                        hintText: 'piece, pack, carton',
                        textInputAction: TextInputAction.done,
                        validator: (value) => (value ?? '').trim().isEmpty ? 'Unit of measure is required' : null,
                      ),
                      const SizedBox(height: 14),
                      _StockPreviewCard(
                        costPrice: _costPriceController.text,
                        openingQty: _openingQtyController.text,
                      ),
                      const SizedBox(height: 18),
                      PrimaryButton(
                        label: isSubmitting ? 'Saving product...' : 'Save product',
                        onPressed: isSubmitting ? null : _saveProduct,
                        expanded: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
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
              if (productsState.isLoading && products.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: LoadingIndicator(message: 'Loading products...'),
                )
              else if (products.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: EmptyStateWidget(
                    title: widget.onboardingFlow ? 'No products yet' : 'Catalogue is empty',
                    message: widget.onboardingFlow
                        ? 'Add at least one product to continue onboarding.'
                        : 'Use the form above to build your product catalogue.',
                    icon: Icons.inventory_2_outlined,
                  ),
                )
              else
                ...products.map((product) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ProductCard(
                        product: product,
                        onDeactivate: product.isActive ? () => _deactivateProduct(product) : null,
                      ),
                    )),
              if (widget.onboardingFlow) ...[
                const SizedBox(height: 12),
               
                Text(
                  'Tier 2 businesses must add products before completing onboarding.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await ref.read(productsControllerProvider.notifier).refreshProducts();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final productInput = ProductInput(
      name: _nameController.text.trim(),
      sellingPrice: _toDouble(_sellingPriceController.text),
      costPrice: _toDouble(_costPriceController.text),
      openingQty: _toDouble(_openingQtyController.text),
      minimumStockQty: _toDouble(_minimumStockQtyController.text),
      unitOfMeasure: _unitController.text.trim(),
    );

    final notifier = ref.read(productsControllerProvider.notifier);
    try {
      await notifier.addProduct(input: productInput);
      if (!mounted) {
        return;
      }
      _clearForm();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product saved successfully.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Future<void> _deactivateProduct(Product product) async {
    final notifier = ref.read(productsControllerProvider.notifier);
    try {
      await notifier.deactivateProduct(productId: product.id);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product.name} deactivated.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  void _continueToOnboarding() {
    Navigator.of(context).pushNamed(AppRoutes.onboardingComplete);
  }

  void _clearForm() {
    _nameController.clear();
    _sellingPriceController.clear();
    _costPriceController.clear();
    _openingQtyController.clear();
    _minimumStockQtyController.clear();
    _unitController.text = 'piece';
    setState(() {});
  }

  String? _amountValidator(String? value) {
    final parsed = double.tryParse((value ?? '').trim());
    if (parsed == null || parsed < 0) {
      return 'Enter a valid amount';
    }
    return null;
  }

  double _toDouble(String value) {
    return double.tryParse(value.trim()) ?? 0;
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.onboardingFlow,
    required this.productCount,
  });

  final bool onboardingFlow;
  final int productCount;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      borderRadius: BorderRadius.circular(24),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.inventory_2_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  onboardingFlow ? 'Set up your product catalogue' : 'Manage products',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  onboardingFlow
                      ? 'Tier 2 businesses must add products first. The backend will calculate opening stock value from what you record here.'
                      : 'Keep pricing, stock, and product records in one place for sales and inventory reporting.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Badge(label: '$productCount products'),
                    _Badge(label: onboardingFlow ? 'Onboarding step' : 'Standalone feature'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          fontSize: 12,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StockPreviewCard extends StatelessWidget {
  const _StockPreviewCard({
    required this.costPrice,
    required this.openingQty,
  });

  final String costPrice;
  final String openingQty;

  @override
  Widget build(BuildContext context) {
    final parsedCost = double.tryParse(costPrice.trim()) ?? 0;
    final parsedQty = double.tryParse(openingQty.trim()) ?? 0;
    final stockValue = parsedCost * parsedQty;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet_outlined, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Opening stock value preview',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            'GH₵ ${stockValue.toStringAsFixed(2)}',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
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
              _MetricChip(label: 'Selling', value: 'GH₵ ${product.sellingPrice.toStringAsFixed(2)}'),
              _MetricChip(label: 'Cost', value: 'GH₵ ${product.costPrice.toStringAsFixed(2)}'),
              _MetricChip(label: 'Opening qty', value: product.openingQty.toStringAsFixed(0)),
              _MetricChip(label: 'Min stock', value: product.minimumStockQty.toStringAsFixed(0)),
              _MetricChip(label: 'Stock value', value: 'GH₵ ${product.stockValue.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}