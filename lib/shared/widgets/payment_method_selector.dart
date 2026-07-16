import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

/// A reusable grid of payment method pills matching the prototype `.pays`
/// component. Generic so it can host both [PaymentMethod] (money movements)
/// and [RestockPaymentMethod] (purchases, which also allow `credit`).
class PaymentMethodSelector<T> extends StatelessWidget {
  const PaymentMethodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.methods,
    required this.methodLabel,
    required this.methodIcon,
    this.accentColor = AppColors.blue,
  });

  final T selected;
  final ValueChanged<T> onChanged;
  final List<T> methods;
  final String Function(T method) methodLabel;
  final IconData Function(T method) methodIcon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 9,
      runSpacing: 9,
      children: methods.map((method) {
        final bool isSelected = method == selected;
        return GestureDetector(
          onTap: () => onChanged(method),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.blueLight : AppColors.surface,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: isSelected ? accentColor : AppColors.line,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  methodIcon(method),
                  size: 18,
                  color: isSelected ? accentColor : AppColors.mute,
                ),
                const SizedBox(width: 8),
                Text(
                  methodLabel(method),
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.blueDark : AppColors.inkSoft,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
