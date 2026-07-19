import '../../domain/entities/sale_request.dart';

class SaleRequestModel {
  const SaleRequestModel({required this.request});

  final SaleRequest request;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'paymentMethod': request.paymentMethod.apiValue,
      'items': request.items.map((item) => item.toJson()).toList(),
      if (request.customerName != null && request.customerName!.trim().isNotEmpty)
        'customerName': request.customerName!.trim(),
      if (request.customerPhone != null && request.customerPhone!.trim().isNotEmpty)
        'customerPhone': request.customerPhone!.trim(),
      if (request.debtorId != null && request.debtorId!.trim().isNotEmpty)
        'debtorId': request.debtorId!.trim(),
      if (request.dueDate != null && request.dueDate!.trim().isNotEmpty)
        'dueDate': request.dueDate!.trim(),
      if (request.receiptPrinted != null) 'receiptPrinted': request.receiptPrinted,
      if (request.receiptSentTo != null && request.receiptSentTo!.trim().isNotEmpty)
        'receiptSentTo': request.receiptSentTo!.trim(),
    };
  }
}
