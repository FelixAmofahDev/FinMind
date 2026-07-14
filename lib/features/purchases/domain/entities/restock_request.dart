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
  });

  final String productId;
  final double quantity;
  final double unitCost;
  final String paymentMethod;
  final String? creditorId;
  final String? supplierName;
  final String? supplierPhone;
  final String? dueDate;
}
