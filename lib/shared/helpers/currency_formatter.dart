import 'package:intl/intl.dart';

class CurrencyFormatter {
  const CurrencyFormatter._();

  static String format(
    num value, {
    String currencyCode = 'GHS',
    String? locale,
    int decimalDigits = 2,
  }) {
    final resolvedLocale = locale ?? (currencyCode == 'GHS' ? 'en_GH' : 'en_US');
    final symbol = currencyCode == 'GHS' ? 'GH₵' : currencyCode;

    return NumberFormat.currency(
      locale: resolvedLocale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    ).format(value);
  }
}
