import 'package:finmind/features/sales/presentation/providers/sales_provider.dart';
import 'package:finmind/features/sales/presentation/widgets/cart_bottom_bar.dart';
import 'package:finmind/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/shared/widgets/empty_state_widget.dart';
import 'package:finmind/shared/widgets/loading_indicator.dart';
import 'package:finmind/shared/dialogs/success_dialog.dart';

import '../../../../features/products/domain/entities/product.dart';
import '../../../../features/debtors/domain/entities/debtor.dart';
import '../../../../features/sales/domain/entities/sale_payment_method.dart';
import '../../../../features/sales/domain/entities/sale_request.dart';
import '../../../../features/sales/domain/entities/sale.dart';
import '../widgets/cart_bottom_sheet.dart';
import '../widgets/sale_product_tile.dart';

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

  final List<CartItem> _cartItems = [];
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
        _cartItems.add(CartItem(product: product, quantity: 1));
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
      _cartItems[index] = CartItem(product: item.product, quantity: newQty);
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
        builder: (context) => CartBottomSheet(
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
                    return SaleProductTile(
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

class CartItem {
  CartItem({required this.product, this.quantity = 1});

  final Product product;
  int quantity;
}

extension _ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
