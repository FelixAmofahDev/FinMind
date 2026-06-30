import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.expanded = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool expanded;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? theme.colorScheme.primary,
      foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
      minimumSize: const Size.fromHeight(52),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      textStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );

    final child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              valueColor: AlwaysStoppedAnimation<Color>(
                foregroundColor ?? theme.colorScheme.onPrimary,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: 10),
              ],
              Flexible(child: Text(label, textAlign: TextAlign.center)),
            ],
          );

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: buttonStyle,
      child: child,
    );

    if (!expanded) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }
}
