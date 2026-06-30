import '../helpers/currency_formatter.dart';

extension NumExtensions on num {
  String toCurrency({
    String currencyCode = 'GHS',
    String? locale,
    int decimalDigits = 2,
  }) {
    return CurrencyFormatter.format(
      this,
      currencyCode: currencyCode,
      locale: locale,
      decimalDigits: decimalDigits,
    );
  }
}
