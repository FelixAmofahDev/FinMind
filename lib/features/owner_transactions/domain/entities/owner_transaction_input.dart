import '../../../../shared/models/payment_method.dart';

/// Payload for recording an owner deposit or withdrawal.
class OwnerTransactionInput {
  const OwnerTransactionInput({
    required this.amount,
    required this.paymentMethod,
    this.notes,
  });

  final double amount;
  final PaymentMethod paymentMethod;
  final String? notes;
}
