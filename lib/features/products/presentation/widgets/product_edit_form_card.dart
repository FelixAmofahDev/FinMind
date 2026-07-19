import 'package:flutter/material.dart';

import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/shared/widgets/app_card.dart';
import 'package:finmind/shared/widgets/app_text_field.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../../domain/entities/product.dart';

class ProductEditFormCard extends StatefulWidget {
  const ProductEditFormCard({
    super.key,
    required this.product,
    required this.onSubmit,
  });

  final Product product;
  final Future<Product?> Function({
    required String name,
    required double sellingPrice,
    required double minimumStockQty,
    required String unitOfMeasure,
    String? sku,
    String? categoryId,
  }) onSubmit;

  @override
  State<ProductEditFormCard> createState() => _ProductEditFormCardState();
}

class _ProductEditFormCardState extends State<ProductEditFormCard> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _sellingPriceController;
  late final TextEditingController _costPriceController;
  late final TextEditingController _minimumStockQtyController;
  late final TextEditingController _unitController;
  late final TextEditingController _skuController;
  late final TextEditingController _categoryController;
  late final TextEditingController _lastPurchasedCostController;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product.name);
    _sellingPriceController = TextEditingController(text: product.sellingPrice.toString());
    _costPriceController = TextEditingController(text: product.costPrice.toString());
    _minimumStockQtyController =
        TextEditingController(text: product.minimumStockQty.toString());
    _unitController = TextEditingController(text: product.unitOfMeasure);
    _skuController = TextEditingController(text: product.sku);
    _categoryController = TextEditingController(text: product.categoryId ?? '');
    _lastPurchasedCostController = TextEditingController(text: product.lastPurchasedCost.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sellingPriceController.dispose();
    _costPriceController.dispose();
    _minimumStockQtyController.dispose();
    _unitController.dispose();
    _skuController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  double? _toDouble(String value) {
    final parsed = double.tryParse(value.trim());
    return parsed;
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Edit product',
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Opening quantity cannot be changed after creation.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _nameController,
              labelText: 'Product name',
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
                    enabled: false,
                    readOnly: true,
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
                    controller: _minimumStockQtyController,
                    labelText: 'Minimum stock',
                    hintText: '0',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: _amountValidator,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    enabled: false,
                    readOnly: true,
                    controller: _lastPurchasedCostController,
                    labelText: 'Last purchased cost',
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
                    controller: _unitController,
                    labelText: 'Unit of measure',
                    hintText: 'e.g. pcs, kg, ltr',
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _skuController,
              labelText: 'SKU (optional)',
              hintText: 'e.g. CB-400',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _categoryController,
              labelText: 'Category ID (optional)',
              hintText: 'Leave blank to clear',
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              label: _isSubmitting ? 'Saving changes...' : 'Save changes',
              onPressed: _isSubmitting ? null : _save,
              expanded: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final sellingPrice = _toDouble(_sellingPriceController.text);
    final costPrice = _toDouble(_costPriceController.text);
    final minimumStockQty = _toDouble(_minimumStockQtyController.text);

    if (sellingPrice == null || costPrice == null || minimumStockQty == null) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter valid numeric values.')),
      );
      return;
    }

    final categoryRaw = _categoryController.text.trim();

    setState(() {
      _isSubmitting = true;
    });

    try {
      final updated = await widget.onSubmit(
        name: _nameController.text.trim(),
        sellingPrice: sellingPrice,
        minimumStockQty: minimumStockQty,
        unitOfMeasure: _unitController.text.trim(),
        sku: _skuController.text.trim().isEmpty ? null : _skuController.text.trim(),
        categoryId: categoryRaw.isEmpty ? null : categoryRaw,
      );
      if (!mounted) {
        return;
      }
      if (updated != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product updated.')),
        );
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String? _amountValidator(String? value) {
    final parsed = double.tryParse((value ?? '').trim());
    if (parsed == null || parsed < 0) {
      return 'Enter a valid amount';
    }
    return null;
  }
}
