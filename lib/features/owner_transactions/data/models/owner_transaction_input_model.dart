import '../../domain/entities/owner_transaction_input.dart';

class OwnerTransactionInputModel {
  const OwnerTransactionInputModel({
    required this.amount,
    required this.paymentMethod,
    this.notes,
  });

  final double amount;
  final String paymentMethod;
  final String? notes;

  factory OwnerTransactionInputModel.fromEntity(OwnerTransactionInput input) {
    return OwnerTransactionInputModel(
      amount: input.amount,
      paymentMethod: input.paymentMethod.apiValue,
      notes: input.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amount': amount,
      'paymentMethod': paymentMethod,
      if (notes != null && notes!.trim().isNotEmpty) 'notes': notes!.trim(),
    };
  }
}
