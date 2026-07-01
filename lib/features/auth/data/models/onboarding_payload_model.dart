import '../../domain/entities/onboarding_payload.dart';

class OnboardingPayloadModel {
  const OnboardingPayloadModel({
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

  factory OnboardingPayloadModel.fromEntity(OnboardingPayload payload) {
    return OnboardingPayloadModel(
      cashInHand: payload.cashInHand,
      mtnMomo: payload.mtnMomo,
      bankBalance: payload.bankBalance,
      stockValue: payload.stockValue,
      debtorsTotal: payload.debtorsTotal,
      creditorsTotal: payload.creditorsTotal,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'cashInHand': cashInHand,
      'mtnMomo': mtnMomo,
      'bankBalance': bankBalance,
      'stockValue': stockValue,
      'debtorsTotal': debtorsTotal,
      'creditorsTotal': creditorsTotal,
    };
  }
}