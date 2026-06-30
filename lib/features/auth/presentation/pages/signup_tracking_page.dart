import 'package:flutter/material.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../widgets/auth_choice_card.dart';
import '../widgets/auth_flow_scaffold.dart';

class SignupTrackingPage extends StatelessWidget {
  const SignupTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthFlowScaffold(
      title: 'Create account',
      stepIndex: 2,
      stepCount: 4,
      onBack: () => Navigator.of(context).pop(),
      subtitle: 'Step 3 of 4 - you can change this later.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'How do you want to track?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          Text(
            'Your level',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          AuthChoiceCard(
            title: 'Tier 1 - Daily totals',
            subtitle: 'Enter your day\'s sales and expenses once each evening. Simplest.',
            icon: Icons.task_alt_rounded,
            accentColor: AppColors.success,
            selected: false,
            onTap: () {},
          ),
          const SizedBox(height: 10),
          AuthChoiceCard(
            title: 'Tier 2 - Sell with POS',
            subtitle: 'Ring up each sale by product. Tracks stock and profit per item.',
            icon: Icons.shopping_cart_checkout_rounded,
            accentColor: AppColors.primary,
            selected: true,
            onTap: () {},
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Continue',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.signupCredentials),
            expanded: true,
          ),
        ],
      ),
    );
  }
}
