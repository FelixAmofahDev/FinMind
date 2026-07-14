import 'package:flutter/material.dart';

import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

class ProductsOnboardingFooter extends StatelessWidget {
  const ProductsOnboardingFooter({
    super.key,
    required this.canContinue,
    required this.onContinue,
  });

  final bool canContinue;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        PrimaryButton(
          label: 'Continue to onboarding',
          onPressed: canContinue ? onContinue : null,
          expanded: true,
        ),
        const SizedBox(height: 8),
        Text(
          'Tier 2 businesses must add products before completing onboarding.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
