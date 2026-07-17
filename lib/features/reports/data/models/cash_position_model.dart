import '../../domain/entities/cash_position_report.dart';

class CashPositionModel {
  const CashPositionModel({
    required this.asOf,
    required this.total,
    required this.accounts,
  });

  factory CashPositionModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final accounts = (data['accounts'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(CashAccountModel.fromJson)
        .toList();

    return CashPositionModel(
      asOf: data['asOf'] as String? ?? '',
      total: data['total'] is num ? (data['total'] as num).toDouble() : 0.0,
      accounts: accounts,
    );
  }

  final String asOf;
  final double total;
  final List<CashAccountModel> accounts;

  CashPositionReport toEntity() {
    return CashPositionReport(
      asOf: asOf,
      total: total,
      accounts: accounts
          .map(
            (account) => CashAccount(
              subtype: account.subtype,
              name: account.name,
              balance: account.balance,
            ),
          )
          .toList(),
    );
  }
}

class CashAccountModel {
  const CashAccountModel({
    required this.subtype,
    required this.name,
    required this.balance,
  });

  factory CashAccountModel.fromJson(Map<String, dynamic> json) {
    return CashAccountModel(
      subtype: json['subtype'] as String? ?? '',
      name: json['name'] as String? ?? '',
      balance: json['balance'] is num ? (json['balance'] as num).toDouble() : 0.0,
    );
  }

  final String subtype;
  final String name;
  final double balance;
}
