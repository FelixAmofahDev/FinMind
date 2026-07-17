import '../../domain/entities/profit_loss_report.dart';

class ProfitLossModel {
  const ProfitLossModel({
    required this.periodFrom,
    required this.periodTo,
    required this.revenue,
    required this.cogs,
    required this.grossProfit,
    required this.expenses,
    required this.netProfit,
    required this.expenseBreakdown,
  });

  factory ProfitLossModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final period = data['period'] as Map<String, dynamic>? ?? {};
    final breakdown = (data['expenseBreakdown'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(ExpenseBreakdownItemModel.fromJson)
        .toList();

    return ProfitLossModel(
      periodFrom: period['from'] as String? ?? '',
      periodTo: period['to'] as String? ?? '',
      revenue: _toDouble(data['revenue']),
      cogs: _toDouble(data['cogs']),
      grossProfit: _toDouble(data['grossProfit']),
      expenses: _toDouble(data['expenses']),
      netProfit: _toDouble(data['netProfit']),
      expenseBreakdown: breakdown,
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return 0.0;
  }

  final String periodFrom;
  final String periodTo;
  final double revenue;
  final double cogs;
  final double grossProfit;
  final double expenses;
  final double netProfit;
  final List<ExpenseBreakdownItemModel> expenseBreakdown;

  ProfitLossReport toEntity() {
    return ProfitLossReport(
      periodFrom: periodFrom,
      periodTo: periodTo,
      revenue: revenue,
      cogs: cogs,
      grossProfit: grossProfit,
      expenses: expenses,
      netProfit: netProfit,
      expenseBreakdown: expenseBreakdown
          .map((item) => ExpenseBreakdownItem(
                category: item.category,
                name: item.name,
                amount: item.amount,
              ))
          .toList(),
    );
  }
}

class ExpenseBreakdownItemModel {
  const ExpenseBreakdownItemModel({
    required this.category,
    required this.name,
    required this.amount,
  });

  factory ExpenseBreakdownItemModel.fromJson(Map<String, dynamic> json) {
    return ExpenseBreakdownItemModel(
      category: json['category'] as String? ?? '',
      name: json['name'] as String? ?? '',
      amount: json['amount'] is num ? (json['amount'] as num).toDouble() : 0.0,
    );
  }

  final String category;
  final String name;
  final double amount;
}
