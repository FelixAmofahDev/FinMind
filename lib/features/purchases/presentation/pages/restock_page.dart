import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/shared/widgets/app_card.dart';
import 'package:finmind/shared/widgets/app_text_field.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../../../products/domain/entities/product.dart';
import '../../domain/entities/restock_request.dart';
import '../providers/purchases_provider.dart';

class RestockPage extends ConsumerStatefulWidget {
  const RestockPage({super.key});

  @override
  ConsumerState<RestockPage> createState() => _RestockPageState();
}

class _RestockPageState extends ConsumerState<RestockPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _quantityController;
  late final TextEditingController _unitCostController;
  late final TextEditingController _supplierNameController;
  late final TextEditingController _supplierPhoneController;
  late final TextEditingController _dueDateController;
  Product _product = const Product(
    id: '',
    name: '',
    sellingPrice: 0,
    costPrice: 0,
    openingQty: 0,
    currentStockQty: 0,
    minimumStockQty: 0,
    unitOfMeasure: '',
    sku: '',
    categoryId: null,
    isActive: true,
    isLowStock: false,
  );
  DateTime? _dueDate;
  String _paymentMethod = 'cash';
  bool _didInit = false;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _unitCostController = TextEditingController();
    _supplierNameController = TextEditingController();
    _supplierPhoneController = TextEditingController();
    _dueDateController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic> && args['product'] is Product) {
        _product = args['product'] as Product;
        _unitCostController.text = _product.costPrice.toString();
      }
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _unitCostController.dispose();
    _supplierNameController.dispose();
    _supplierPhoneController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  bool get _isCredit => _paymentMethod == 'credit';

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dueDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final quantity = double.tryParse(_quantityController.text.trim()) ?? 0;
    final unitCost = double.tryParse(_unitCostController.text.trim()) ?? 0;

    if (quantity <= 0) {
      _showError('Enter a quantity greater than zero.');
      return;
    }

    String? supplierName;
    String? supplierPhone;
    String? dueDate;

    if (_isCredit) {
      supplierName = _supplierNameController.text.trim();
      if (supplierName.isEmpty) {
        _showError('Supplier name is required for credit purchases.');
        return;
      }
      supplierPhone = _supplierPhoneController.text.trim();
      dueDate = _dueDate == null ? null : DateFormat('yyyy-MM-dd').format(_dueDate!);
    }

    final request = RestockRequest(
      productId: _product.id,
      quantity: quantity,
      unitCost: unitCost,
      paymentMethod: _paymentMethod,
      supplierName: supplierName,
      supplierPhone: supplierPhone,
      dueDate: dueDate,
    );

    await ref.read(restockControllerProvider.notifier).restock(request: request);
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final restockState = ref.watch(restockControllerProvider);

    ref.listen(restockControllerProvider, (prev, next) {
      if (next is AsyncData<void>) {
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } else if (next is AsyncError) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error.toString())),
          );
        }
      }
    });

    final unitLabel = _product.unitOfMeasure.isNotEmpty
        ? ' ${_product.unitOfMeasure}'
        : '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restock product'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _product.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Current stock: ${_product.currentStockQty.toStringAsFixed(0)} x$unitLabel',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _quantityController,
                labelText: 'Quantity received',
                hintText: '0',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  final parsed = double.tryParse((value ?? '').trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _unitCostController,
                labelText: 'Unit cost',
                hintText: '0.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  final parsed = double.tryParse((value ?? '').trim());
                  if (parsed == null || parsed < 0) {
                    return 'Enter a valid cost';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text(
                'Passing the unit cost updates the product\'s weighted-average cost price.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Payment method',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment<String>(
                    value: 'cash',
                    label: Text('Cash'),
                    icon: Icon(Icons.payments_outlined),
                  ),
                  ButtonSegment<String>(
                    value: 'credit',
                    label: Text('Credit'),
                    icon: Icon(Icons.account_balance_wallet_outlined),
                  ),
                ],
                selected: <String>{_paymentMethod},
                onSelectionChanged: (selection) {
                  setState(() {
                    _paymentMethod = selection.first;
                  });
                },
              ),
              if (_isCredit) ...[
                const SizedBox(height: 16),
                AppTextField(
                  controller: _supplierNameController,
                  labelText: 'Supplier name',
                  hintText: 'e.g. Kumasi Wholesale Ltd.',
                  validator: (value) =>
                      (value ?? '').trim().isEmpty ? 'Supplier name is required' : null,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _supplierPhoneController,
                  labelText: 'Supplier phone (optional)',
                  hintText: 'e.g. 0240000000',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  readOnly: true,
                  onTap: _pickDueDate,
                  labelText: 'Due date (optional)',
                  hintText: 'Select a due date',
                  controller: _dueDateController,
                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                ),
              ],
              const SizedBox(height: 24),
              PrimaryButton(
                label: restockState.isLoading ? 'Recording restock...' : 'Record restock',
                onPressed: restockState.isLoading ? null : _submit,
                expanded: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
