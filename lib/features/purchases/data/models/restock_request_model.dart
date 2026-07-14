import '../../domain/entities/restock_request.dart';

class RestockRequestModel {
  const RestockRequestModel({required this.request});

  final RestockRequest request;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'paymentMethod': request.paymentMethod,
      'items': <Map<String, dynamic>>[
        <String, dynamic>{
          'productId': request.productId,
          'quantity': request.quantity,
          'unitCost': request.unitCost,
        },
      ],
      if (request.creditorId != null && request.creditorId!.trim().isNotEmpty)
        'creditorId': request.creditorId!.trim(),
      if (request.supplierName != null && request.supplierName!.trim().isNotEmpty)
        'supplierName': request.supplierName!.trim(),
      if (request.supplierPhone != null && request.supplierPhone!.trim().isNotEmpty)
        'supplierPhone': request.supplierPhone!.trim(),
      if (request.dueDate != null && request.dueDate!.trim().isNotEmpty)
        'dueDate': request.dueDate!.trim(),
    };
  }
}
