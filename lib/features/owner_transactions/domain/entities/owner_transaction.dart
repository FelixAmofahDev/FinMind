import '../../../../shared/models/payment_method.dart';
import 'owner_transaction_type.dart';

/// A capital transaction recorded by the business owner — either a deposit
/// (equity injection) or a withdrawal (personal drawing).
class OwnerTransaction {
  const OwnerTransaction({
    required this.id,
    required this.amount,
    required this.paymentMethod,
    required this.notes,
    required this.type,
    required this.createdAt,
  });

  final String id;
  final double amount;
  final PaymentMethod paymentMethod;
  final String notes;
  final OwnerTransactionType type;
  final DateTime? createdAt;
}
