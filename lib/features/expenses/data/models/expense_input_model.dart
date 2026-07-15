import '../../domain/entities/expense_input.dart';

class ExpenseInputModel {
  const ExpenseInputModel({
    required this.amount,
    required this.category,
    required this.paymentMethod,
    this.paidTo,
    this.notes,
  });

  final double amount;
  final String category;
  final String paymentMethod;
  final String? paidTo;
  final String? notes;

  factory ExpenseInputModel.fromEntity(ExpenseInput input) {
    return ExpenseInputModel(
      amount: input.amount,
      category: input.category.apiValue,
      paymentMethod: input.paymentMethod.apiValue,
      paidTo: input.paidTo,
      notes: input.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amount': amount,
      'category': category,
      'paymentMethod': paymentMethod,
      if (paidTo != null && paidTo!.trim().isNotEmpty) 'paidTo': paidTo!.trim(),
      if (notes != null && notes!.trim().isNotEmpty) 'notes': notes!.trim(),
    };
  }
}
