import '../../../../shared/models/payment_method.dart';

/// Payload for recording a repayment from a debtor.
class DebtorPayment {
  const DebtorPayment({
    required this.amountPaid,
    required this.paymentMethod,
    required this.paymentDate,
    this.notes,
  });

  final double amountPaid;
  final PaymentMethod paymentMethod;
  final DateTime paymentDate;
  final String? notes;
}
