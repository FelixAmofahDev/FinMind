import 'package:flutter/material.dart';

import 'package:finmind/core/theme/colors.dart';

class AuthSampleField extends StatelessWidget {
  const AuthSampleField({
    super.key,
    required this.label,
    required this.value,
    this.obscureText = false,
    this.suffix,
    this.prefixText,
  });

  final String label;
  final String value;
  final bool obscureText;
  final Widget? suffix;
  final String? prefixText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 7),
        TextFormField(
          initialValue: value,
          obscureText: obscureText,
          readOnly: true,
          decoration: InputDecoration(
            prefixText: prefixText,
            suffixIcon: suffix,
            filled: true,
            fillColor: theme.colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          ),
        ),
      ],
    );
  }
}
