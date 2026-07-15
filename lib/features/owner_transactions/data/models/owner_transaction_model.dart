import '../../../../shared/models/payment_method.dart';
import '../../domain/entities/owner_transaction.dart';
import '../../domain/entities/owner_transaction_type.dart';

class OwnerTransactionModel extends OwnerTransaction {
  const OwnerTransactionModel({
    required super.id,
    required super.amount,
    required super.paymentMethod,
    required super.notes,
    required super.type,
    required super.createdAt,
  });

  factory OwnerTransactionModel.fromJson(
    Map<String, dynamic> json, {
    required OwnerTransactionType type,
  }) {
    return OwnerTransactionModel(
      id: json['id'] as String? ?? '',
      amount: _toDouble(json['amount']),
      paymentMethod: PaymentMethod.fromApi(json['paymentMethod'] as String?),
      notes: json['notes'] as String? ?? '',
      type: type,
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
      return double.tryParse(value.trim()) ?? 0;
    }
    return 0;
  }
}
