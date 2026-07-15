/// A merged, read-only snapshot of the business' money-with-people position,
/// aggregated from the debtors and creditors summaries.
class MoneyOverview {
  const MoneyOverview({
    required this.totalOwedToYou,
    required this.totalYouOwe,
  });

  final double totalOwedToYou;
  final double totalYouOwe;

  /// Positive means people owe you more than you owe suppliers.
  double get netPosition => totalOwedToYou - totalYouOwe;

  static const MoneyOverview empty = MoneyOverview(
    totalOwedToYou: 0,
    totalYouOwe: 0,
  );
}
