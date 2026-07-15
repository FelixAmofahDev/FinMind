import 'debtor.dart';

class DebtorsSummary {
  const DebtorsSummary({
    required this.totalOutstanding,
    required this.totalDebtorsCount,
    required this.overdueCount,
    required this.debtors,
  });

  final double totalOutstanding;
  final int totalDebtorsCount;
  final int overdueCount;
  final List<Debtor> debtors;

  static const DebtorsSummary empty = DebtorsSummary(
    totalOutstanding: 0,
    totalDebtorsCount: 0,
    overdueCount: 0,
    debtors: <Debtor>[],
  );
}
