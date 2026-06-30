import 'package:flutter/material.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../widgets/auth_flow_scaffold.dart';
import '../widgets/auth_sample_field.dart';

class SignupLocationPage extends StatelessWidget {
  const SignupLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthFlowScaffold(
      title: 'Create account',
      stepIndex: 1,
      stepCount: 4,
      onBack: () => Navigator.of(context).pop(),
      subtitle: 'Step 2 of 4 - owner and location.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'You & where you trade',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          const AuthSampleField(label: 'Your name', value: 'Akosua Mensah'),
          const SizedBox(height: 15),
          const AuthSampleField(label: 'Phone number', value: '024 412 3456'),
          const SizedBox(height: 15),
          _DropdownLikeField(label: 'Region', value: 'Greater Accra', onTap: () {}),
          const SizedBox(height: 15),
          _DropdownLikeField(label: 'District', value: 'Ablekuma North', onTap: () {}),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Continue',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.signupTracking),
            expanded: true,
          ),
        ],
      ),
    );
  }
}

class _DropdownLikeField extends StatelessWidget {
  const _DropdownLikeField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 7),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(13),
          child: Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
