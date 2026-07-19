import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/shared/extensions/num_extensions.dart';
import 'package:finmind/shared/widgets/app_card.dart';
import 'package:finmind/shared/widgets/app_text_field.dart';
import 'package:finmind/shared/widgets/app_segmented_control.dart';
import 'package:finmind/shared/widgets/payment_method_selector.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../../../products/domain/entities/product.dart';
import '../../../creditors/domain/entities/creditor.dart';
import '../../domain/entities/restock_payment_method.dart';
import '../../domain/entities/restock_request.dart';
import '../providers/purchases_provider.dart';
import '../widgets/creditor_picker_sheet.dart';

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
  late final TextEditingController _notesController;
  Product _product = const Product(
    id: '',
    name: '',
    sellingPrice: 0,
    costPrice: 0,
    lastPurchasedCost: 0,
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
  RestockPaymentMethod _paymentMethod = RestockPaymentMethod.cash;
  bool _didInit = false;
  int _creditTypeIndex = 1;
  Creditor? _selectedCreditor;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _unitCostController = TextEditingController();
    _supplierNameController = TextEditingController();
    _supplierPhoneController = TextEditingController();
    _dueDateController = TextEditingController();
    _notesController = TextEditingController();
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
    _notesController.dispose();
    super.dispose();
  }

  bool get _isCredit => _paymentMethod.isCredit;

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
    String? creditorId;

    if (_isCredit) {
      dueDate = _dueDate == null ? null : DateFormat('yyyy-MM-dd').format(_dueDate!);
      if (_creditTypeIndex == 1) {
        if (_selectedCreditor == null) {
          _showError('Select a supplier or switch to new supplier.');
          return;
        }
        creditorId = _selectedCreditor!.id;
      } else {
        supplierName = _supplierNameController.text.trim();
        if (supplierName.isEmpty) {
          _showError('Supplier name is required for credit purchases.');
          return;
        }
        supplierPhone = _supplierPhoneController.text.trim();
      }
    }

    final request = RestockRequest(
      productId: _product.id,
      quantity: quantity,
      unitCost: unitCost,
      paymentMethod: _paymentMethod,
      creditorId: creditorId,
      supplierName: supplierName,
      supplierPhone: supplierPhone,
      dueDate: dueDate,
      notes: _isCredit ? _notesController.text.trim() : null,
    );

    await ref.read(restockControllerProvider.notifier).restock(request: request);
  }

  Future<void> _openCreditorPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreditorPickerSheet(
        onSelected: _onCreditorSelected,
      ),
    );
    if (selected != null && mounted) {
      _onCreditorSelected(selected);
    }
  }

  void _onCreditorSelected(Creditor creditor) {
    setState(() {
      _selectedCreditor = creditor;
    });
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
              PaymentMethodSelector<RestockPaymentMethod>(
                methods: const [
                  RestockPaymentMethod.cash,
                  RestockPaymentMethod.mtnMomo,
                  RestockPaymentMethod.telecel,
                  RestockPaymentMethod.airtel,
                  RestockPaymentMethod.bank,
                  RestockPaymentMethod.credit,
                ],
                selected: _paymentMethod,
                methodLabel: (method) => method.label,
                methodIcon: (method) => method.icon,
                onChanged: (method) => setState(() => _paymentMethod = method),
              ),
              if (_isCredit) ...[
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Purchase type',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    AppSegmentedControl(
                      segments: const ['New supplier', 'Existing supplier'],
                      selectedIndex: _creditTypeIndex,
                      onChanged: (index) {
                        setState(() => _creditTypeIndex = index);
                        if (index == 0) {
                          _selectedCreditor = null;
                          _supplierNameController.clear();
                          _supplierPhoneController.clear();
                        } else {
                          _supplierNameController.clear();
                          _supplierPhoneController.clear();
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_creditTypeIndex == 1) ...[
                  TextButton.icon(
                    onPressed: () => _openCreditorPicker(context),
                    icon: const Icon(Icons.person_search_outlined),
                    label: Text(_selectedCreditor != null
                        ? 'Change supplier'
                        : 'Select existing supplier'),
                  ),
                    if (_selectedCreditor != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: AppColors.coralLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _selectedCreditor!.name.trim().isNotEmpty
                                    ? _selectedCreditor!.name.trim()[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.coralDark,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _selectedCreditor!.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.ink,
                                ),
                              ),
                            ),
                            Text(
                              _selectedCreditor!.amountOutstanding.toCurrency(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.coralDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  const SizedBox(height: 12),
                ] else ...[
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
                ],
                AppTextField(
                  readOnly: true,
                  onTap: _pickDueDate,
                  labelText: 'Due date (optional)',
                  hintText: 'Select a due date',
                  controller: _dueDateController,
                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _notesController,
                  labelText: 'Notes (optional)',
                  hintText: 'e.g. Agreed to settle at month end',
                  maxLines: 2,
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
