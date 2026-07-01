import 'package:flutter/material.dart';

import 'package:finmind/core/theme/colors.dart';

class AuthSampleField extends StatelessWidget {
  const AuthSampleField({
    super.key,
    required this.label,
    required this.value,
    this.controller,
    this.obscureText = false,
    this.readOnly = true,
    this.suffix,
    this.prefixText,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onChanged,
    this.onTap,
    this.autofocus = false,
  });

  final String label;
  final String value;
  final TextEditingController? controller;
  final bool obscureText;
  final bool readOnly;
  final Widget? suffix;
  final String? prefixText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool autofocus;

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
          controller: controller,
          initialValue: controller == null ? value : null,
          obscureText: obscureText,
          readOnly: readOnly,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          onChanged: onChanged,
          onTap: onTap,
          autofocus: autofocus,
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
