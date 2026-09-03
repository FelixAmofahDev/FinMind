class TrialBalanceReport {
  const TrialBalanceReport({
    required this.asOf,
    required this.accounts,
    required this.totalDebit,
    required this.totalCredit,
    required this.isBalanced,
  });

  final String asOf;
  final List<TrialBalanceAccount> accounts;
  final double totalDebit;
  final double totalCredit;
  final bool isBalanced;
}

class TrialBalanceAccount {
  const TrialBalanceAccount({
    required this.code,
    required this.name,
    required this.type,
    required this.debit,
    required this.credit,
  });

  final String code;
  final String name;
  final String type;
  final double debit;
  final double credit;
}
