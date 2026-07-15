import 'package:intl/intl.dart';

import '../../domain/entities/debtor_payment.dart';

class DebtorPaymentRequestModel {
  const DebtorPaymentRequestModel({
    required this.amountPaid,
    required this.paymentMethod,
    required this.paymentDate,
    this.notes,
  });

  final double amountPaid;
  final String paymentMethod;
  final DateTime paymentDate;
  final String? notes;

  factory DebtorPaymentRequestModel.fromEntity(DebtorPayment payment) {
    return DebtorPaymentRequestModel(
      amountPaid: payment.amountPaid,
      paymentMethod: payment.paymentMethod.apiValue,
      paymentDate: payment.paymentDate,
      notes: payment.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amountPaid': amountPaid,
      'paymentMethod': paymentMethod,
      'paymentDate': DateFormat('yyyy-MM-dd').format(paymentDate),
      if (notes != null && notes!.trim().isNotEmpty) 'notes': notes!.trim(),
    };
  }
}
