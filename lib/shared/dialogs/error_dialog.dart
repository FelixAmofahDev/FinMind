import 'package:flutter/material.dart';

class ErrorDialog {
  const ErrorDialog._();

  static Future<void> show(
    BuildContext context, {
    required String message,
    String title = 'Something went wrong',
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Icon(
            Icons.error_outline,
            color: Theme.of(dialogContext).colorScheme.error,
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
