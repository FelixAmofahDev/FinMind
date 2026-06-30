import 'package:flutter/material.dart';

class ConfirmDialog {
  const ConfirmDialog._();

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Yes',
    String cancelText = 'Cancel',
    bool destructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(cancelText),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: destructive ? theme.colorScheme.error : null,
                foregroundColor: destructive ? theme.colorScheme.onError : null,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(confirmText),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
