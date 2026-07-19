import 'package:flutter/material.dart';

enum SalePaymentMethod {
  cash('cash', 'Cash', Icons.payments_outlined),
  mtnMomo('mtn_momo', 'MTN MoMo', Icons.smartphone_outlined),
  telecel('telecel', 'Telecel', Icons.smartphone_outlined),
  airtel('airtel', 'AirtelTigo', Icons.smartphone_outlined),
  bank('bank', 'Bank', Icons.account_balance_outlined),
  credit('credit', 'Credit', Icons.account_balance_wallet_outlined);

  const SalePaymentMethod(this.apiValue, this.label, this.icon);

  final String apiValue;
  final String label;
  final IconData icon;

  static SalePaymentMethod fromApi(String? value) {
    return SalePaymentMethod.values.firstWhere(
      (method) => method.apiValue == value,
      orElse: () => SalePaymentMethod.cash,
    );
  }

  bool get isCredit => this == SalePaymentMethod.credit;
}
