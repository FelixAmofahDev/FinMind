import '../../domain/entities/debtors_summary.dart';
import 'debtor_model.dart';

class DebtorsSummaryModel extends DebtorsSummary {
  const DebtorsSummaryModel({
    required super.totalOutstanding,
    required super.totalDebtorsCount,
    required super.overdueCount,
    required super.debtors,
  });

  factory DebtorsSummaryModel.fromJson(Map<String, dynamic> json) {
    final rawDebtors = json['debtors'];
    final debtors = rawDebtors is List
        ? rawDebtors
            .whereType<Map<String, dynamic>>()
            .map(DebtorModel.fromJson)
            .toList()
        : <DebtorModel>[];

    return DebtorsSummaryModel(
      totalOutstanding: _toDouble(json['totalOwed']),
      totalDebtorsCount: _toInt(json['count']) ?? debtors.length,
      overdueCount: _toInt(json['overdueCount']) ?? 0,
      debtors: debtors,
    );
  }

  static double _toDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value.trim()) ?? 0;
    }
    return 0;
  }

  static int? _toInt(Object? value) {
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value.trim());
    }
    return null;
  }
}
