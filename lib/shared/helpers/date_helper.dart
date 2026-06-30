import 'package:intl/intl.dart';

class DateHelper {
  const DateHelper._();

  static String formatDate(DateTime date, {String pattern = 'dd MMM yyyy'}) {
    return DateFormat(pattern).format(date);
  }

  static String formatDateTime(DateTime dateTime, {String pattern = 'dd MMM yyyy, hh:mm a'}) {
    return DateFormat(pattern).format(dateTime);
  }

  static String formatTime(DateTime time, {String pattern = 'hh:mm a'}) {
    return DateFormat(pattern).format(time);
  }
}
