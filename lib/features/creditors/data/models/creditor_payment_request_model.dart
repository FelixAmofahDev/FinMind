import 'package:intl/intl.dart';

import '../../domain/entities/creditor_payment.dart';

class CreditorPaymentRequestModel {
  const CreditorPaymentRequestModel({
    required this.amountPaid,
    required this.paymentMethod,
    required this.paymentDate,
    this.notes,
  });

  final double amountPaid;
  final String paymentMethod;
  final DateTime paymentDate;
  final String? notes;

  factory CreditorPaymentRequestModel.fromEntity(CreditorPayment payment) {
    return CreditorPaymentRequestModel(
      amountPaid: payment.amountPaid,
      paymentMethod: payment.paymentMethod.apiValue,
      paymentDate: payment.paymentDate,
      notes: payment.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amount': amountPaid,
      'paymentMethod': paymentMethod,
      'paymentDate': DateFormat('yyyy-MM-dd').format(paymentDate),
      if (notes != null && notes!.trim().isNotEmpty) 'notes': notes!.trim(),
    };
  }
}
