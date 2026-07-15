import '../../../../shared/models/payment_method.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_category.dart';

class ExpenseModel extends Expense {
  const ExpenseModel({
    required super.id,
    required super.amount,
    required super.category,
    required super.paymentMethod,
    required super.paidTo,
    required super.notes,
    required super.createdAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String? ?? '',
      amount: _toDouble(json['amount']),
      category: ExpenseCategory.fromApi(json['category'] as String?),
      paymentMethod: PaymentMethod.fromApi(json['paymentMethod'] as String?),
      paidTo: json['paidTo'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
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
