/// Payload for editing a creditor's details. Only name, phone and notes can be
/// updated by the owner.
class CreditorUpdate {
  const CreditorUpdate({
    this.name,
    this.phone,
    this.notes,
  });

  final String? name;
  final String? phone;
  final String? notes;
}
