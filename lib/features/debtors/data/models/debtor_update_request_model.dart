import '../../domain/entities/debtor_update.dart';

class DebtorUpdateRequestModel {
  const DebtorUpdateRequestModel({
    this.name,
    this.phone,
    this.notes,
  });

  final String? name;
  final String? phone;
  final String? notes;

  factory DebtorUpdateRequestModel.fromEntity(DebtorUpdate update) {
    return DebtorUpdateRequestModel(
      name: update.name,
      phone: update.phone,
      notes: update.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (name != null && name!.trim().isNotEmpty) 'name': name!.trim(),
      if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
      if (notes != null) 'notes': notes!.trim(),
    };
  }
}
