import '../../domain/entities/creditors_summary.dart';
import 'creditor_model.dart';

class CreditorsSummaryModel extends CreditorsSummary {
  const CreditorsSummaryModel({
    required super.totalOutstanding,
    required super.totalCreditorsCount,
    required super.overdueCount,
    required super.creditors,
  });

  factory CreditorsSummaryModel.fromJson(Map<String, dynamic> json) {
    final rawCreditors = json['creditors'];
    final creditors = rawCreditors is List
        ? rawCreditors
            .whereType<Map<String, dynamic>>()
            .map(CreditorModel.fromJson)
            .toList()
        : <CreditorModel>[];

    return CreditorsSummaryModel(
      totalOutstanding: _toDouble(json['totalOutstanding']),
      totalCreditorsCount:
          _toInt(json['totalCreditorsCount']) ?? creditors.length,
      overdueCount: _toInt(json['overdueCount']) ?? 0,
      creditors: creditors,
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
