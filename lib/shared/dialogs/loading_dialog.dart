import 'package:flutter/material.dart';

class LoadingDialog {
  const LoadingDialog._();

  static Future<void> show(
    BuildContext context, {
    String message = 'Loading...',
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.4),
                ),
                const SizedBox(width: 16),
                Flexible(child: Text(message)),
              ],
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }
}
