import 'package:flutter/material.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../widgets/auth_choice_card.dart';
import '../widgets/auth_flow_scaffold.dart';
import '../widgets/auth_sample_field.dart';

class SignupBusinessPage extends StatelessWidget {
  const SignupBusinessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthFlowScaffold(
      title: 'Create account',
      stepIndex: 0,
      stepCount: 4,
      onBack: () => Navigator.of(context).pop(),
      subtitle: 'Step 1 of 4 - the basics.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tell us about your shop',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          const AuthSampleField(
            label: 'Shop name',
            value: 'Akosua Provisions',
          ),
          const SizedBox(height: 15),
          Text(
            'What kind of business?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 7),
          AuthChoiceCard(
            title: 'Provision store',
            subtitle: 'Pick the closest - it is only used to personalise your app, not your accounting.',
            icon: Icons.storefront_rounded,
            accentColor: AppColors.primary,
            selected: true,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          AuthChoiceCard(
            title: 'Supermarket',
            subtitle: 'Alternative business type shown in the prototype.',
            icon: Icons.shopping_bag_rounded,
            accentColor: AppColors.secondary,
            selected: false,
            onTap: () {},
          ),
          const SizedBox(height: 14),
          Text(
            'Pick the closest - it is only used to personalise your app, not your accounting.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Continue',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.signupLocation),
            expanded: true,
          ),
        ],
      ),
    );
  }
}
