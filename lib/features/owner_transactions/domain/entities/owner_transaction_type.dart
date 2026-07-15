/// Whether an owner capital transaction is money going into the business
/// (deposit) or being taken out for personal use (withdrawal).
enum OwnerTransactionType {
  deposit('Deposit', 'Owner deposit'),
  withdrawal('Withdrawal', 'Owner withdrawal');

  const OwnerTransactionType(this.label, this.longLabel);

  final String label;
  final String longLabel;
}
