import 'package:flutter/material.dart';

class ReceiptPreviewDialog {
  const ReceiptPreviewDialog._();

  static Future<bool> show(
    BuildContext context, {
    required String receiptText,
    String title = 'Receipt Preview',
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);
        return AlertDialog(
          title: Text(title),
          contentPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: theme.colorScheme.surface,

          content: SizedBox(
            width: 360,
            child: SingleChildScrollView(
              child: Text(
                receiptText,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.4,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Print'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}
