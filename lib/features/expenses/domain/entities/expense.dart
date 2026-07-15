import '../../../../shared/models/payment_method.dart';
import 'expense_category.dart';

class Expense {
  const Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.paymentMethod,
    required this.paidTo,
    required this.notes,
    required this.createdAt,
  });

  final String id;
  final double amount;
  final ExpenseCategory category;
  final PaymentMethod paymentMethod;
  final String paidTo;
  final String notes;
  final DateTime? createdAt;
}
