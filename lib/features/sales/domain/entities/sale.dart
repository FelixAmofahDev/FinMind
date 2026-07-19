class Sale {
  const Sale({
    required this.referenceNumber,
    required this.totalRevenue,
    required this.totalCogs,
    required this.grossProfit,
    required this.itemCount,
    required this.isCredit,
    this.debtorId,
  });

  final String referenceNumber;
  final double totalRevenue;
  final double totalCogs;
  final double grossProfit;
  final int itemCount;
  final bool isCredit;
  final String? debtorId;
}
