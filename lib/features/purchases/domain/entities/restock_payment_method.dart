import 'package:flutter/material.dart';

/// Payment methods accepted when recording a purchase / restock. This includes
/// `credit` (buying from a supplier on account) which is not part of the
/// everyday money-movement set.
enum RestockPaymentMethod {
  cash('cash', 'Cash', Icons.payments_outlined),
  mtnMomo('mtn_momo', 'MTN MoMo', Icons.smartphone_outlined),
  telecel('telecel', 'Telecel', Icons.smartphone_outlined),
  airtel('airtel', 'AirtelTigo', Icons.smartphone_outlined),
  bank('bank', 'Bank', Icons.account_balance_outlined),
  credit('credit', 'Credit', Icons.account_balance_wallet_outlined);

  const RestockPaymentMethod(this.apiValue, this.label, this.icon);

  final String apiValue;
  final String label;
  final IconData icon;

  static RestockPaymentMethod fromApi(String? value) {
    return RestockPaymentMethod.values.firstWhere(
      (method) => method.apiValue == value,
      orElse: () => RestockPaymentMethod.cash,
    );
  }

  bool get isCredit => this == RestockPaymentMethod.credit;
}
