class CashPositionReport {
  const CashPositionReport({
    required this.asOf,
    required this.total,
    required this.accounts,
  });

  final String asOf;
  final double total;
  final List<CashAccount> accounts;
}

class CashAccount {
  const CashAccount({
    required this.subtype,
    required this.name,
    required this.balance,
  });

  final String subtype;
  final String name;
  final double balance;
}
