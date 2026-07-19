import 'sale_payment_method.dart';

class SaleLineItem {
  const SaleLineItem({
    required this.productId,
    required this.quantity,
  });

  final String productId;
  final int quantity;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'productId': productId,
      'quantity': quantity,
    };
  }
}

class SaleRequest {
  const SaleRequest({
    required this.paymentMethod,
    required this.items,
    this.customerName,
    this.customerPhone,
    this.debtorId,
    this.dueDate,
    this.receiptPrinted,
    this.receiptSentTo,
  });

  final SalePaymentMethod paymentMethod;
  final List<SaleLineItem> items;
  final String? customerName;
  final String? customerPhone;
  final String? debtorId;
  final String? dueDate;
  final bool? receiptPrinted;
  final String? receiptSentTo;
}
