import 'package:intl/intl.dart';

import '../../domain/entities/creditor_update.dart';

class CreditorUpdateRequestModel {
  const CreditorUpdateRequestModel({
    this.name,
    this.phone,
    this.totalOwedAmount,
    this.dueDate,
  });

  final String? name;
  final String? phone;
  final double? totalOwedAmount;
  final DateTime? dueDate;

  factory CreditorUpdateRequestModel.fromEntity(CreditorUpdate update) {
    return CreditorUpdateRequestModel(
      name: update.name,
      phone: update.phone,
      totalOwedAmount: update.totalOwedAmount,
      dueDate: update.dueDate,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (name != null && name!.trim().isNotEmpty) 'name': name!.trim(),
      if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
      if (totalOwedAmount != null) 'totalOwedAmount': totalOwedAmount,
      if (dueDate != null) 'dueDate': DateFormat('yyyy-MM-dd').format(dueDate!),
    };
  }
}
