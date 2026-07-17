class ProfitLossReport {
  const ProfitLossReport({
    required this.periodFrom,
    required this.periodTo,
    required this.revenue,
    required this.cogs,
    required this.grossProfit,
    required this.expenses,
    required this.netProfit,
    required this.expenseBreakdown,
  });

  final String periodFrom;
  final String periodTo;
  final double revenue;
  final double cogs;
  final double grossProfit;
  final double expenses;
  final double netProfit;
  final List<ExpenseBreakdownItem> expenseBreakdown;
}

class ExpenseBreakdownItem {
  const ExpenseBreakdownItem({
    required this.category,
    required this.name,
    required this.amount,
  });

  final String category;
  final String name;
  final double amount;
}
