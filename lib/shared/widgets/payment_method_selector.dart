import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../models/payment_method.dart';

/// A reusable grid of payment method pills matching the prototype `.pays`
/// component. Enforces the strict payment method contract app-wide.
class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    this.methods = PaymentMethod.values,
    this.accentColor = AppColors.blue,
  });

  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onChanged;
  final List<PaymentMethod> methods;
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
                  method.icon,
                  size: 18,
                  color: isSelected ? accentColor : AppColors.mute,
                ),
                const SizedBox(width: 8),
                Text(
                  method.label,
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
