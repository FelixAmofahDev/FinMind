/// Payload for editing a debtor's details.
class DebtorUpdate {
  const DebtorUpdate({
    this.name,
    this.phone,
    this.totalDebtAmount,
    this.dueDate,
  });

  final String? name;
  final String? phone;
  final double? totalDebtAmount;
  final DateTime? dueDate;
}
