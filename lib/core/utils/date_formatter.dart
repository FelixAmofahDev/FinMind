import 'package:intl/intl.dart';

class DateFormatter {
  const DateFormatter._();

  static String formatDate(DateTime date, {String pattern = 'dd MMM yyyy'}) {
    return DateFormat(pattern).format(date);
  }

  static String formatDateTime(DateTime dateTime, {String pattern = 'dd MMM yyyy, hh:mm a'}) {
    return DateFormat(pattern).format(dateTime);
  }
}
