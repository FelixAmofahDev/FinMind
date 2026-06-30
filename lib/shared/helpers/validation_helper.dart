class ValidationHelper {
  const ValidationHelper._();

  static String? requiredField(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$').hasMatch(input)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? password(String? value, {int minLength = 8}) {
    final input = value ?? '';
    if (input.isEmpty) {
      return 'Password is required';
    }
    if (input.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    return null;
  }

  static String? number(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Value is required';
    }
    if (num.tryParse(input) == null) {
      return 'Enter a valid number';
    }
    return null;
  }
}
