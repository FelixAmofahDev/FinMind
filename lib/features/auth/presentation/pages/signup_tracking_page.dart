import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth_flow_scaffold.dart';

class SignupTrackingPage extends ConsumerWidget {
  const SignupTrackingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(signupDraftProvider);

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
          RadioListTile<String>(
            value: 'tier1',
            groupValue: draft.tier,
            onChanged: (value) {
              if (value == null) {
                return;
              }
              ref.read(signupDraftProvider.notifier).updateTrackingStep(
                    tier: value,
                    recordingMode: draft.recordingMode,
                  );
            },
            title: const Text('Tier 1 - Daily totals'),
            subtitle: const Text('Enter your day\'s sales and expenses once each evening.'),
          ),
          RadioListTile<String>(
            value: 'tier2',
            groupValue: draft.tier,
            onChanged: (value) {
              if (value == null) {
                return;
              }
              ref.read(signupDraftProvider.notifier).updateTrackingStep(
                    tier: value,
                    recordingMode: draft.recordingMode,
                  );
            },
            title: const Text('Tier 2 - Sell with POS'),
            subtitle: const Text('Ring up each sale by product. Tracks stock and profit per item.'),
          ),
          const SizedBox(height: 14),
          Text(
            'Recording mode',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 8),
          RadioListTile<String>(
            value: 'daily_summary',
            groupValue: draft.recordingMode,
            onChanged: (value) {
              if (value == null) {
                return;
              }
              ref.read(signupDraftProvider.notifier).updateTrackingStep(
                    tier: draft.tier,
                    recordingMode: value,
                  );
            },
            title: const Text('Daily summary'),
            subtitle: const Text('Simple totals by day.'),
          ),
          RadioListTile<String>(
            value: 'transaction',
            groupValue: draft.recordingMode,
            onChanged: (value) {
              if (value == null) {
                return;
              }
              ref.read(signupDraftProvider.notifier).updateTrackingStep(
                    tier: draft.tier,
                    recordingMode: value,
                  );
            },
            title: const Text('Transaction'),
            subtitle: const Text('Track every sale and movement in detail.'),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Continue',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.signupCredentials);
            },
            expanded: true,
          ),
        ],
      ),
    );
  }
}
