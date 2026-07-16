import 'restock_payment_method.dart';

class RestockRequest {
  const RestockRequest({
    required this.productId,
    required this.quantity,
    required this.unitCost,
    required this.paymentMethod,
    this.creditorId,
    this.supplierName,
    this.supplierPhone,
    this.dueDate,
    this.notes,
  });

  final String productId;
  final double quantity;
  final double unitCost;
  final RestockPaymentMethod paymentMethod;
  final String? creditorId;
  final String? supplierName;
  final String? supplierPhone;
  final String? dueDate;
  final String? notes;
}
