import 'package:flutter/material.dart';

import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/shared/widgets/app_text_field.dart';

import '../../../../features/products/domain/entities/product_import_row.dart';

class ProductImportRowWidget extends StatefulWidget {
  const ProductImportRowWidget({
    super.key,
    required this.row,
    required this.index,
    required this.onChanged,
    this.onRemove,
  });

  final ProductImportRow row;
  final int index;
  final ValueChanged<ProductImportRow> onChanged;
  final VoidCallback? onRemove;

  @override
  State<ProductImportRowWidget> createState() => _ProductImportRowWidgetState();
}

class _ProductImportRowWidgetState extends State<ProductImportRowWidget> {
  late final TextEditingController _nameController;
  late final TextEditingController _sellingPriceController;
  late final TextEditingController _costPriceController;
  late final TextEditingController _openingQtyController;
  late final TextEditingController _minimumStockQtyController;
  late final TextEditingController _unitOfMeasureController;
  late final TextEditingController _skuController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.row.name);
    _sellingPriceController = TextEditingController(text: widget.row.sellingPrice);
    _costPriceController = TextEditingController(text: widget.row.costPrice);
    _openingQtyController = TextEditingController(text: widget.row.openingQty);
    _minimumStockQtyController = TextEditingController(text: widget.row.minimumStockQty);
    _unitOfMeasureController = TextEditingController(text: widget.row.unitOfMeasure);
    _skuController = TextEditingController(text: widget.row.sku);
  }

  @override
  void didUpdateWidget(covariant ProductImportRowWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_nameController.text != widget.row.name) {
      _nameController.text = widget.row.name;
    }
    if (_sellingPriceController.text != widget.row.sellingPrice) {
      _sellingPriceController.text = widget.row.sellingPrice;
    }
    if (_costPriceController.text != widget.row.costPrice) {
      _costPriceController.text = widget.row.costPrice;
    }
    if (_openingQtyController.text != widget.row.openingQty) {
      _openingQtyController.text = widget.row.openingQty;
    }
    if (_minimumStockQtyController.text != widget.row.minimumStockQty) {
      _minimumStockQtyController.text = widget.row.minimumStockQty;
    }
    if (_unitOfMeasureController.text != widget.row.unitOfMeasure) {
      _unitOfMeasureController.text = widget.row.unitOfMeasure;
    }
    if (_skuController.text != widget.row.sku) {
      _skuController.text = widget.row.sku;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sellingPriceController.dispose();
    _costPriceController.dispose();
    _openingQtyController.dispose();
    _minimumStockQtyController.dispose();
    _unitOfMeasureController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.row.hasError;
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: hasError ? AppColors.coralLight : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasError ? AppColors.coral : AppColors.line,
          width: hasError ? 1.4 : 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.ink.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${widget.index + 1}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppTextField(
                  controller: _nameController,
                  labelText: 'Product name *',
                  hintText: 'e.g. Milk 400g',
                  onChanged: (_) => widget.onChanged(widget.row.copyWith(name: _nameController.text, error: null)),
                ),
              ),
              if (widget.onRemove != null)
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.mute),
                  tooltip: 'Remove row',
                ),
            ],
          ),
          if (hasError) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.coralDark.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.coral.withOpacity(0.25)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded, size: 16, color: AppColors.coralDark),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.row.error!,
                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.coralDark, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _sellingPriceController,
                  labelText: 'Selling price *',
                  hintText: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => widget.onChanged(widget.row.copyWith(sellingPrice: _sellingPriceController.text, error: null)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppTextField(
                  controller: _costPriceController,
                  labelText: 'Cost price *',
                  hintText: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => widget.onChanged(widget.row.copyWith(costPrice: _costPriceController.text, error: null)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _openingQtyController,
                  labelText: 'Opening qty',
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  onChanged: (_) => widget.onChanged(widget.row.copyWith(openingQty: _openingQtyController.text, error: null)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppTextField(
                  controller: _minimumStockQtyController,
                  labelText: 'Min stock qty',
                  hintText: '0',
                  keyboardType: TextInputType.number,
                  onChanged: (_) => widget.onChanged(widget.row.copyWith(minimumStockQty: _minimumStockQtyController.text, error: null)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _unitOfMeasureController,
                  labelText: 'Unit',
                  hintText: 'piece',
                  onChanged: (_) => widget.onChanged(widget.row.copyWith(unitOfMeasure: _unitOfMeasureController.text, error: null)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AppTextField(
                  controller: _skuController,
                  labelText: 'SKU',
                  hintText: 'optional',
                  onChanged: (_) => widget.onChanged(widget.row.copyWith(sku: _skuController.text, error: null)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
