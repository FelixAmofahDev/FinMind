import 'package:flutter/material.dart';

class SuccessDialog {
  const SuccessDialog._();

  static Future<void> show(
    BuildContext context, {
    required String message,
    String title = 'Success',
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          icon: Icon(
            Icons.check_circle_outline,
            color: theme.colorScheme.primary,
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
