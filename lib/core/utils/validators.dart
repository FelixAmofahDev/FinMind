class Validators {
  const Validators._();

  static String? email(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) {
      return 'Email is required';
    }

    final regex = RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(input)) {
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

    final parsed = num.tryParse(input);
    if (parsed == null) {
      return 'Enter a valid number';
    }

    return null;
  }
}
