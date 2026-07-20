import 'package:finmind/shared/extensions/num_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/shared/widgets/app_card.dart';
import 'package:finmind/shared/widgets/app_text_field.dart';
import 'package:finmind/shared/widgets/app_segmented_control.dart';
import 'package:finmind/shared/widgets/payment_method_selector.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../../../../features/debtors/domain/entities/debtor.dart';
import '../../../../features/sales/domain/entities/sale_payment_method.dart';
import '../../../../features/sales/presentation/providers/sales_provider.dart';
import '../../../../features/sales/presentation/widgets/customer_picker_sheet.dart';
import '../pages/sales_page.dart';

class CartBottomSheet extends ConsumerStatefulWidget {
  const CartBottomSheet({
    super.key,
    required this.cartItems,
    required this.paymentMethod,
    required this.creditTypeIndex,
    required this.selectedDebtor,
    required this.customerNameController,
    required this.customerPhoneController,
    required this.dueDate,
    required this.dueDateController,
    required this.isCredit,
    required this.cartTotal,
    required this.formKey,
    required this.onPaymentMethodChanged,
    required this.onCreditTypeChanged,
    required this.onCustomerSelected,
    required this.onPickDueDate,
    required this.onUpdateQuantity,
    required this.onRemoveItem,
    required this.onSubmit,
    required this.onClose,
  });

  final List<CartItem> cartItems;
  final SalePaymentMethod paymentMethod;
  final int creditTypeIndex;
  final Debtor? selectedDebtor;
  final TextEditingController customerNameController;
  final TextEditingController customerPhoneController;
  final DateTime? dueDate;
  final TextEditingController dueDateController;
  final bool isCredit;
  final double cartTotal;
  final GlobalKey<FormState> formKey;
  final ValueChanged<SalePaymentMethod> onPaymentMethodChanged;
  final ValueChanged<int> onCreditTypeChanged;
  final ValueChanged<Debtor> onCustomerSelected;
  final VoidCallback onPickDueDate;
  final void Function(String, int) onUpdateQuantity;
  final void Function(String) onRemoveItem;
  final VoidCallback onSubmit;
  final VoidCallback onClose;

  @override
  ConsumerState<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends ConsumerState<CartBottomSheet> {
  late List<CartItem> _localCartItems;
  late SalePaymentMethod _localPaymentMethod;
  late int _localCreditTypeIndex;
  late Debtor? _localSelectedDebtor;

  @override
  void initState() {
    super.initState();
    _localCartItems = widget.cartItems
        .map((item) => CartItem(product: item.product, quantity: item.quantity))
        .toList();
    _localPaymentMethod = widget.paymentMethod;
    _localCreditTypeIndex = widget.creditTypeIndex;
    _localSelectedDebtor = widget.selectedDebtor;
  }

  @override
  Widget build(BuildContext context) {
    final saleState = ref.watch(salesControllerProvider);
    final localTotal = _localCartItems.fold<double>(
      0,
      (sum, item) => sum + (item.product.sellingPrice * item.quantity),
    );
    final formattedTotal = localTotal % 1 == 0
        ? localTotal.toStringAsFixed(0)
        : localTotal.toStringAsFixed(2);

    return Container(
      color: AppColors.background,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
        minHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.line,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Cart (${_localCartItems.fold(0, (s, i) => s + i.quantity)} items)',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Flexible(
            child: Form(
              key: widget.formKey,
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  ..._localCartItems.map((item) {
                    final lineTotal = item.product.sellingPrice * item.quantity;
                    final lineFormatted = lineTotal % 1 == 0
                        ? lineTotal.toStringAsFixed(0)
                        : lineTotal.toStringAsFixed(2);

                    return AppCard(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'GHS ${item.product.sellingPrice.toStringAsFixed(2)} each',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  widget.onUpdateQuantity(item.product.id, -1);
                                  setState(() {
                                    final idx = _localCartItems.indexWhere((i) => i.product.id == item.product.id);
                                    if (idx != -1) {
                                      final newQty = _localCartItems[idx].quantity - 1;
                                      if (newQty <= 0) {
                                        _localCartItems.removeAt(idx);
                                      } else {
                                        _localCartItems[idx] = CartItem(product: _localCartItems[idx].product, quantity: newQty);
                                      }
                                    }
                                  });
                                },
                                icon: const Icon(Icons.remove_circle_outline, size: 20),
                                visualDensity: VisualDensity.compact,
                              ),
                              SizedBox(
                                width: 24,
                                child: Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  widget.onUpdateQuantity(item.product.id, 1);
                                  setState(() {
                                    final idx = _localCartItems.indexWhere((i) => i.product.id == item.product.id);
                                    if (idx != -1) {
                                      _localCartItems[idx] = CartItem(product: _localCartItems[idx].product, quantity: _localCartItems[idx].quantity + 1);
                                    }
                                  });
                                },
                                icon: const Icon(Icons.add_circle_outline, size: 20),
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Column(
                            children: [
                              Text(
                                'GHS $lineFormatted',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.ink,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  widget.onRemoveItem(item.product.id);
                                  setState(() {
                                    _localCartItems.removeWhere((i) => i.product.id == item.product.id);
                                  });
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Remove',
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  const Text(
                    'Payment method',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  PaymentMethodSelector<SalePaymentMethod>(
                    methods: const [
                      SalePaymentMethod.cash,
                      SalePaymentMethod.mtnMomo,
                      SalePaymentMethod.telecel,
                      SalePaymentMethod.airtel,
                      SalePaymentMethod.bank,
                      SalePaymentMethod.credit,
                    ],
                    selected: _localPaymentMethod,
                    methodLabel: (method) => method.label,
                    methodIcon: (method) => method.icon,
                    onChanged: (method) {
                      setState(() => _localPaymentMethod = method);
                      widget.onPaymentMethodChanged(method);
                    },
                  ),
                  if (_localPaymentMethod.isCredit) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Sale type',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppSegmentedControl(
                      segments: const ['New customer', 'Existing customer'],
                      selectedIndex: _localCreditTypeIndex,
                      onChanged: (index) {
                        setState(() => _localCreditTypeIndex = index);
                        widget.onCreditTypeChanged(index);
                      },
                    ),
                    const SizedBox(height: 12),
                    if (_localCreditTypeIndex == 0) ...[
                      AppTextField(
                        controller: widget.customerNameController,
                        labelText: 'Customer name',
                        hintText: 'e.g. Kofi Manu',
                        validator: (value) =>
                            (value ?? '').trim().isEmpty ? 'Name is required' : null,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: widget.customerPhoneController,
                        labelText: 'Phone (optional)',
                        hintText: 'e.g. 0240000000',
                        keyboardType: TextInputType.phone,
                      ),
                    ] else ...[
                      TextButton.icon(
                        onPressed: () async {
                          await showModalBottomSheet<dynamic>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => CustomerPickerSheet(
                              onSelected: (debtor) {
                                widget.onCustomerSelected(debtor);
                                if (mounted) {
                                  setState(() => _localSelectedDebtor = debtor);
                                }
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.person_search_outlined),
                        label: Text(_localSelectedDebtor != null
                            ? 'Change customer'
                            : 'Select existing customer'),
                      ),
                      if (_localSelectedDebtor != null) ...[
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
                                  color: AppColors.blueLight,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _localSelectedDebtor!.name.trim().isNotEmpty
                                      ? _localSelectedDebtor!.name.trim()[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.blueDark,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  _localSelectedDebtor!.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColors.ink,
                                  ),
                                ),
                              ),
                              Text(
                                _localSelectedDebtor!.amountOutstanding.toCurrency(),
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
                    ],
                    const SizedBox(height: 12),
                    AppTextField(
                      readOnly: true,
                      onTap: widget.onPickDueDate,
                      labelText: 'Due date (optional)',
                      hintText: 'Select a due date',
                      controller: widget.dueDateController,
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              'GHS $formattedTotal',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: PrimaryButton(
                          label: saleState.isLoading ? 'Processing...' : 'Complete sale',
                          onPressed: saleState.isLoading ? null : widget.onSubmit,
                          expanded: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
