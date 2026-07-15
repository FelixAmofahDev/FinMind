import '../../../../shared/models/payment_method.dart';
import 'expense_category.dart';

/// Payload for logging a new expense.
class ExpenseInput {
  const ExpenseInput({
    required this.amount,
    required this.category,
    required this.paymentMethod,
    this.paidTo,
    this.notes,
  });

  final double amount;
  final ExpenseCategory category;
  final PaymentMethod paymentMethod;
  final String? paidTo;
  final String? notes;
}
