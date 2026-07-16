/// Payload for editing a debtor's details. Only name, phone and notes can be
/// updated by the owner.
class DebtorUpdate {
  const DebtorUpdate({
    this.name,
    this.phone,
    this.notes,
  });

  final String? name;
  final String? phone;
  final String? notes;
}
