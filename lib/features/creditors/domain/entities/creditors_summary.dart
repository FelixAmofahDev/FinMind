import 'creditor.dart';

class CreditorsSummary {
  const CreditorsSummary({
    required this.totalOutstanding,
    required this.totalCreditorsCount,
    required this.overdueCount,
    required this.creditors,
  });

  final double totalOutstanding;
  final int totalCreditorsCount;
  final int overdueCount;
  final List<Creditor> creditors;

  static const CreditorsSummary empty = CreditorsSummary(
    totalOutstanding: 0,
    totalCreditorsCount: 0,
    overdueCount: 0,
    creditors: <Creditor>[],
  );
}
