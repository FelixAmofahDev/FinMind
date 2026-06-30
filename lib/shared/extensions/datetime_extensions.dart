import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String formatDate([String pattern = 'dd MMM yyyy']) {
    return DateFormat(pattern).format(this);
  }

  String formatTime([String pattern = 'hh:mm a']) {
    return DateFormat(pattern).format(this);
  }
}
