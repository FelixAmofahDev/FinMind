/// Payload for editing a creditor's details.
class CreditorUpdate {
  const CreditorUpdate({
    this.name,
    this.phone,
    this.totalOwedAmount,
    this.dueDate,
  });

  final String? name;
  final String? phone;
  final double? totalOwedAmount;
  final DateTime? dueDate;
}
