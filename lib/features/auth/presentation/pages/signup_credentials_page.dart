import 'package:flutter/material.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../widgets/auth_flow_scaffold.dart';
import '../widgets/auth_sample_field.dart';

class SignupCredentialsPage extends StatelessWidget {
  const SignupCredentialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthFlowScaffold(
      title: 'Create account',
      stepIndex: 3,
      stepCount: 4,
      onBack: () => Navigator.of(context).pop(),
      subtitle: 'Step 4 of 4 - we\'ll email a code to confirm it\'s you.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Your login',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          const AuthSampleField(label: 'Email', value: 'akosua@gmail.com'),
          const SizedBox(height: 15),
          const AuthSampleField(
            label: 'Password',
            value: 'goodpass12',
            obscureText: true,
          ),
          const SizedBox(height: 10),
          Text(
            'At least 8 characters. You\'ll use this to sign in next time.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Create account & send code',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.verifyEmail),
            expanded: true,
          ),
        ],
      ),
    );
  }
}
