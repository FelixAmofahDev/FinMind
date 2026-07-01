class OnboardingPayload {
  const OnboardingPayload({
    required this.cashInHand,
    required this.mtnMomo,
   
    required this.bankBalance,
    required this.stockValue,
    required this.debtorsTotal,
    required this.creditorsTotal,
  });

  final double cashInHand;
  final double mtnMomo;
  final double bankBalance;
  final double stockValue;
  final double debtorsTotal;
  final double creditorsTotal;
}