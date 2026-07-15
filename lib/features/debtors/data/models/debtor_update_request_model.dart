import 'package:intl/intl.dart';

import '../../domain/entities/debtor_update.dart';

class DebtorUpdateRequestModel {
  const DebtorUpdateRequestModel({
    this.name,
    this.phone,
    this.totalDebtAmount,
    this.dueDate,
  });

  final String? name;
  final String? phone;
  final double? totalDebtAmount;
  final DateTime? dueDate;

  factory DebtorUpdateRequestModel.fromEntity(DebtorUpdate update) {
    return DebtorUpdateRequestModel(
      name: update.name,
      phone: update.phone,
      totalDebtAmount: update.totalDebtAmount,
      dueDate: update.dueDate,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (name != null && name!.trim().isNotEmpty) 'name': name!.trim(),
      if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
      if (totalDebtAmount != null) 'totalDebtAmount': totalDebtAmount,
      if (dueDate != null) 'dueDate': DateFormat('yyyy-MM-dd').format(dueDate!),
    };
  }
}
