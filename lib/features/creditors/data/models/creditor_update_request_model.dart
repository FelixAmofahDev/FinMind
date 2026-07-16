import '../../domain/entities/creditor_update.dart';

class CreditorUpdateRequestModel {
  const CreditorUpdateRequestModel({
    this.name,
    this.phone,
    this.notes,
  });

  final String? name;
  final String? phone;
  final String? notes;

  factory CreditorUpdateRequestModel.fromEntity(CreditorUpdate update) {
    return CreditorUpdateRequestModel(
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
