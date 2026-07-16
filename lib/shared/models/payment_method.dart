import 'package:flutter/material.dart';

/// Payment methods accepted across the entire app.
///
/// The API validates these strictly using the [apiValue]:
/// `cash` | `mtn_momo` | `telecel` | `airtel` | `bank`.
enum PaymentMethod {
  cash('cash', 'Cash', Icons.payments_outlined),
  mtnMomo('mtn_momo', 'MTN MoMo', Icons.smartphone_outlined),
  telecel('telecel', 'Telecel', Icons.smartphone_outlined),
  airtel('airtel', 'AirtelTigo', Icons.smartphone_outlined),
  bank('bank', 'Bank', Icons.account_balance_outlined);
  //credit('credit', 'Credit', Icons.credit_card_outlined);

  const PaymentMethod(this.apiValue, this.label, this.icon);

  /// The exact value expected by the backend.
  final String apiValue;

  /// A human friendly label for the UI.
  final String label;

  /// A representative icon for the method.
  final IconData icon;

  static PaymentMethod fromApi(String? value) {
    return PaymentMethod.values.firstWhere(
      (method) => method.apiValue == value,
      orElse: () => PaymentMethod.cash,
    );
  }
}
