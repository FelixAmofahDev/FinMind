import '../../domain/entities/purchase.dart';

class PurchaseModel extends Purchase {
  const PurchaseModel({
    required super.id,
    required super.paymentMethod,
    required super.totalCost,
    required super.createdAt,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: json['id'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? '',
      totalCost: _toDouble(json['totalCost']),
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  static double _toDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }
}
