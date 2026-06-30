import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.elevation = 0,
    this.border,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BorderRadius? borderRadius;
  final double elevation;
  final BorderSide? border;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveRadius = borderRadius ?? BorderRadius.circular(16);

    return Card(
      elevation: elevation,
      color: color ?? theme.colorScheme.surface,
      margin: margin,
      shape: RoundedRectangleBorder(
        borderRadius: effectiveRadius,
        side: border ?? BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
