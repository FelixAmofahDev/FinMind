extension StringExtensions on String {
  bool get isEmail {
    final value = trim();
    if (value.isEmpty) {
      return false;
    }

    return RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$').hasMatch(value);
  }

  bool get isPhoneNumber {
    final value = replaceAll(RegExp(r'[\s\-\(\)]'), '').trim();
    if (value.isEmpty) {
      return false;
    }

    return RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value);
  }

  String capitalize() {
    final value = trim();
    if (value.isEmpty) {
      return value;
    }

    return value[0].toUpperCase() + value.substring(1);
  }
}
