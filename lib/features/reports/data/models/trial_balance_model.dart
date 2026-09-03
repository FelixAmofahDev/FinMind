import '../../domain/entities/trial_balance_report.dart';

class TrialBalanceModel {
  const TrialBalanceModel({
    required this.asOf,
    required this.accounts,
    required this.totalDebit,
    required this.totalCredit,
    required this.isBalanced,
  });

  factory TrialBalanceModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final accounts = (data['accounts'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(TrialBalanceAccountModel.fromJson)
        .toList();

    return TrialBalanceModel(
      asOf: data['asOf'] as String? ?? '',
      accounts: accounts,
      totalDebit: data['totalDebit'] is num
          ? (data['totalDebit'] as num).toDouble()
          : 0.0,
      totalCredit: data['totalCredit'] is num
          ? (data['totalCredit'] as num).toDouble()
          : 0.0,
      isBalanced: data['isBalanced'] as bool? ?? false,
    );
  }

  final String asOf;
  final List<TrialBalanceAccountModel> accounts;
  final double totalDebit;
  final double totalCredit;
  final bool isBalanced;

  TrialBalanceReport toEntity() {
    return TrialBalanceReport(
      asOf: asOf,
      accounts: accounts
          .map(
            (account) => TrialBalanceAccount(
              code: account.code,
              name: account.name,
              type: account.type,
              debit: account.debit,
              credit: account.credit,
            ),
          )
          .toList(),
      totalDebit: totalDebit,
      totalCredit: totalCredit,
      isBalanced: isBalanced,
    );
  }
}

class TrialBalanceAccountModel {
  const TrialBalanceAccountModel({
    required this.code,
    required this.name,
    required this.type,
    required this.debit,
    required this.credit,
  });

  factory TrialBalanceAccountModel.fromJson(Map<String, dynamic> json) {
    return TrialBalanceAccountModel(
      code: json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
      debit: json['debit'] is num ? (json['debit'] as num).toDouble() : 0.0,
      credit: json['credit'] is num ? (json['credit'] as num).toDouble() : 0.0,
    );
  }

  final String code;
  final String name;
  final String type;
  final double debit;
  final double credit;
}
