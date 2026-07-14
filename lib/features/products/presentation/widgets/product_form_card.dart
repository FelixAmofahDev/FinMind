import 'package:flutter/material.dart';

import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/shared/widgets/app_card.dart';
import 'package:finmind/shared/widgets/app_text_field.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/product_input.dart';
import 'product_stock_preview_card.dart';

class ProductFormCard extends StatefulWidget {
  const ProductFormCard({
    super.key,
    required this.onSubmit,
  });

  final Future<Product?> Function(ProductInput input) onSubmit;

  @override
  State<ProductFormCard> createState() => _ProductFormCardState();
}

class _ProductFormCardState extends State<ProductFormCard> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _sellingPriceController;
  late final TextEditingController _costPriceController;
  late final TextEditingController _openingQtyController;
  late final TextEditingController _minimumStockQtyController;
  late final TextEditingController _unitController;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _sellingPriceController = TextEditingController();
    _costPriceController = TextEditingController();
    _openingQtyController = TextEditingController();
    _minimumStockQtyController = TextEditingController();
    _unitController = TextEditingController(text: 'piece');
    _attachListeners();
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

  void _attachListeners() {
    _nameController.addListener(_rebuild);
    _sellingPriceController.addListener(_rebuild);
    _costPriceController.addListener(_rebuild);
    _openingQtyController.addListener(_rebuild);
    _minimumStockQtyController.addListener(_rebuild);
    _unitController.addListener(_rebuild);
  }

  void _rebuild() {
    if (mounted) {
      setState(() {});
    }
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
            ProductStockPreviewCard(
              costPrice: _costPriceController.text,
              openingQty: _openingQtyController.text,
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              label: _isSubmitting ? 'Saving product...' : 'Save product',
              onPressed: _isSubmitting ? null : _saveProduct,
              expanded: true,
            ),
          ],
        ),
      ),
    );
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

    setState(() {
      _isSubmitting = true;
    });

    try {
      final created = await widget.onSubmit(productInput);
      if (!mounted) {
        return;
      }
      if (created != null) {
        _clearForm();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product saved successfully.')),
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

  void _clearForm() {
    _nameController.clear();
    _sellingPriceController.clear();
    _costPriceController.clear();
    _openingQtyController.clear();
    _minimumStockQtyController.clear();
    _unitController.text = 'piece';
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
