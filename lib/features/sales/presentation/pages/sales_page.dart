import 'package:finmind/features/sales/presentation/providers/sales_provider.dart';
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
import 'package:finmind/shared/widgets/empty_state_widget.dart';
import 'package:finmind/shared/widgets/loading_indicator.dart';
import 'package:finmind/shared/dialogs/success_dialog.dart';

import '../../../../features/products/domain/entities/product.dart';
import '../../../../features/debtors/domain/entities/debtor.dart';
import '../../../../features/sales/domain/entities/sale_payment_method.dart';
import '../../../../features/sales/domain/entities/sale_request.dart';
import '../../../../features/sales/domain/entities/sale.dart';
import '../widgets/cart_bottom_bar.dart';
import '../widgets/customer_picker_sheet.dart';

class SalesPage extends ConsumerStatefulWidget {
  const SalesPage({super.key});

  @override
  ConsumerState<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends ConsumerState<SalesPage> {
  final _searchController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<_CartItem> _cartItems = [];
  SalePaymentMethod _paymentMethod = SalePaymentMethod.cash;
  int _creditTypeIndex = 0;
  Debtor? _selectedDebtor;
  DateTime? _dueDate;
  bool _isCartOpen = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    ref.read(salesSearchProvider.notifier).setSearch(query);
    ref.read(salesProductsControllerProvider.notifier).refresh();
  }

  bool get _isCredit => _paymentMethod.isCredit;

  double get _cartTotal => _cartItems.fold<double>(
    0,
    (sum, item) => sum + (item.product.sellingPrice * item.quantity),
  );

  int get _cartItemCount =>
      _cartItems.fold<int>(0, (sum, item) => sum + item.quantity);

  void _addToCart(Product product) {
    final currentStock = product.currentStockQty.toInt();
    final existing = _cartItems.firstWhereOrNull((item) => item.product.id == product.id);
    final inCart = existing?.quantity ?? 0;

    if (inCart >= currentStock) {
      _showError('Not enough stock for ${product.name}.');
      return;
    }

    setState(() {
      if (existing != null) {
        existing.quantity++;
      } else {
        _cartItems.add(_CartItem(product: product, quantity: 1));
      }
    });
  }

  void _removeFromCart(String productId) {
    setState(() {
      _cartItems.removeWhere((item) => item.product.id == productId);
    });
  }

  void _updateQuantity(String productId, int delta) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index == -1) return;

    final item = _cartItems[index];
    final newQty = item.quantity + delta;
    final maxStock = item.product.currentStockQty.toInt();

    if (newQty <= 0) {
      _removeFromCart(productId);
      return;
    }

    if (newQty > maxStock) {
      _showError('Only $maxStock available in stock.');
      return;
    }

    setState(() {
      _cartItems[index] = _CartItem(product: item.product, quantity: newQty);
    });
  }

  void _clearCart() {
    setState(() {
      _cartItems.clear();
    });
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null && mounted) {
      setState(() {
        _dueDate = picked;
        _dueDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _onCustomerSelected(Debtor debtor) {
    setState(() {
      _selectedDebtor = debtor;
    });
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _submit() async {
    if (_cartItems.isEmpty) {
      _showError('Add at least one product to the cart.');
      return;
    }

    String? customerName;
    String? customerPhone;
    String? debtorId;
    String? dueDate;

    if (_isCredit) {
      dueDate = _dueDate == null ? null : DateFormat('yyyy-MM-dd').format(_dueDate!);
      if (_creditTypeIndex == 0) {
        customerName = _customerNameController.text.trim();
        if (customerName.isEmpty) {
          _showError('Customer name is required for credit sales.');
          return;
        }
        customerPhone = _customerPhoneController.text.trim();
      } else {
        if (_selectedDebtor == null) {
          _showError('Select a customer or switch to new customer.');
          return;
        }
        debtorId = _selectedDebtor!.id;
      }
    }

    final request = SaleRequest(
      paymentMethod: _paymentMethod,
      items: _cartItems
          .map((item) => SaleLineItem(productId: item.product.id, quantity: item.quantity))
          .toList(),
      customerName: customerName,
      customerPhone: customerPhone,
      debtorId: debtorId,
      dueDate: dueDate,
    );

    await ref.read(salesControllerProvider.notifier).createSale(request: request);
  }

  void _openCartSheet() {
    if (_cartItems.isEmpty) return;
    setState(() => _isCartOpen = true);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CartBottomSheet(
        cartItems: _cartItems,
        paymentMethod: _paymentMethod,
        creditTypeIndex: _creditTypeIndex,
        selectedDebtor: _selectedDebtor,
        customerNameController: _customerNameController,
        customerPhoneController: _customerPhoneController,
        dueDate: _dueDate,
        dueDateController: _dueDateController,
        isCredit: _isCredit,
        cartTotal: _cartTotal,
        formKey: _formKey,
        onPaymentMethodChanged: (method) {
          setState(() => _paymentMethod = method);
        },
        onCreditTypeChanged: (index) {
          setState(() => _creditTypeIndex = index);
        },
        onCustomerSelected: _onCustomerSelected,
        onPickDueDate: _pickDueDate,
        onUpdateQuantity: _updateQuantity,
        onRemoveItem: _removeFromCart,
        onSubmit: _submit,
        onClose: () {
          setState(() => _isCartOpen = false);
          Navigator.of(context).pop();
        },
      ),
    ).then((_) {
      if (mounted) {
        setState(() => _isCartOpen = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(salesProductsControllerProvider);

    ref.listen<AsyncValue<Sale?>>(salesControllerProvider, (prev, next) {
      if (next is AsyncData<Sale?>) {
        final sale = next.value;
        if (sale != null && mounted) {
          SuccessDialog.show(
            context,
            message: 'Sale recorded successfully.\nReference: ${sale.referenceNumber}',
          );
          _clearCart();
        }
      } else if (next is AsyncError) {
        _showError(next.error.toString());
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Sale'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (_cartItemCount > 0)
            TextButton.icon(
              onPressed: _clearCart,
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Clear'),
            ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: AppTextField(
              controller: _searchController,
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search_outlined, size: 18),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : null,
            ),
          ),
          Expanded(
            child: productsState.when(
              loading: () => const Center(
                child: LoadingIndicator(message: 'Loading products...'),
              ),
              error: (error, _) => Center(
                child: EmptyStateWidget(
                  icon: Icons.error_outline,
                  title: 'Could not load products',
                  message: error.toString(),
                  action: TextButton(
                    onPressed: () =>
                        ref.read(salesProductsControllerProvider.notifier).refresh(),
                    child: const Text('Retry'),
                  ),
                ),
              ),
              data: (products) {
                if (products.isEmpty) {
                  return const Center(
                    child: EmptyStateWidget(
                      icon: Icons.inventory_2_outlined,
                      title: 'No products found',
                      message: 'Try a different search term.',
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _ProductTile(
                      product: product,
                      onAddToCart: () => _addToCart(product),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, _isCartOpen ? 0 : 16),
        child: CartBottomBar(
          itemCount: _cartItemCount,
          total: _cartTotal,
          onTap: _openCartSheet,
        ),
      ),
    );
  }
}

class _CartItem {
  _CartItem({required this.product, this.quantity = 1});

  final Product product;
  int quantity;
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.product,
    required this.onAddToCart,
  });

  final Product product;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final formattedPrice = product.sellingPrice % 1 == 0
        ? product.sellingPrice.toStringAsFixed(0)
        : product.sellingPrice.toStringAsFixed(2);

    final stock = product.currentStockQty.toInt();
    final isLowStock = product.isLowStock || stock <= 0;

    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'GHS $formattedPrice',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isLowStock ? '$stock left' : '$stock in stock',
                  style: TextStyle(
                    fontSize: 12,
                    color: isLowStock ? AppColors.coralDark : AppColors.textSecondary,
                    fontWeight: isLowStock ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLowStock ? null : onAddToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text(isLowStock ? 'Out of stock' : 'Add to cart'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartBottomSheet extends ConsumerStatefulWidget {
  const _CartBottomSheet({
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

  final List<_CartItem> cartItems;
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
  ConsumerState<_CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends ConsumerState<_CartBottomSheet> {
  late List<_CartItem> _localCartItems;
  late SalePaymentMethod _localPaymentMethod;
  late int _localCreditTypeIndex;
  late Debtor? _localSelectedDebtor;

  @override
  void initState() {
    super.initState();
    _localCartItems = widget.cartItems.map((item) => _CartItem(product: item.product, quantity: item.quantity)).toList();
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
                                        _localCartItems[idx] = _CartItem(product: _localCartItems[idx].product, quantity: newQty);
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
                                      _localCartItems[idx] = _CartItem(product: _localCartItems[idx].product, quantity: _localCartItems[idx].quantity + 1);
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

extension _ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
