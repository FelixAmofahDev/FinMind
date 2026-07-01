import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';
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
      subtitle: 'Step 3 of 4 · set how the books should work.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.tune_rounded, color: AppColors.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Choose the operating model that fits the shop.',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'When you switch tier, FinMind automatically adjusts the default recording mode. You can still override it below.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _SectionHeader(
            title: 'Your level',
            subtitle: 'Tier changes the default tracking mode.',
          ),
          const SizedBox(height: 12),
          _SelectablePlanCard(
            title: 'Tier 1',
            subtitle: 'Daily totals',
            description: 'Enter one summary each day. Clean and simple.',
            icon: Icons.receipt_long_rounded,
            selected: draft.tier == 'tier1',
            accentColor: AppColors.secondary,
            onTap: () {
              ref.read(signupDraftProvider.notifier).updateTrackingStep(
                    tier: 'tier1',
                    recordingMode: 'daily_summary',
                  );
            },
          ),
          const SizedBox(height: 10),
          _SelectablePlanCard(
            title: 'Tier 2',
            subtitle: 'POS transactions',
            description: 'Ring up every sale by product and track stock with precision.',
            icon: Icons.point_of_sale_rounded,
            selected: draft.tier == 'tier2',
            accentColor: AppColors.primary,
            onTap: () {
              ref.read(signupDraftProvider.notifier).updateTrackingStep(
                    tier: 'tier2',
                    recordingMode: 'transaction',
                  );
            },
          ),
          const SizedBox(height: 18),
          _SectionHeader(
            title: 'Recording mode',
            subtitle: 'You can change this even after choosing a tier.',
          ),
          const SizedBox(height: 12),
          _SelectableModeCard(
            title: 'Daily summary',
            subtitle: 'Best for quick end-of-day entry.',
            selected: draft.recordingMode == 'daily_summary',
            accentColor: AppColors.secondary,
            onTap: () {
              ref.read(signupDraftProvider.notifier).updateTrackingStep(
                    tier: draft.tier,
                    recordingMode: 'daily_summary',
                  );
            },
          ),
          const SizedBox(height: 10),
          _SelectableModeCard(
            title: 'Transaction',
            subtitle: 'Best for detailed sales, inventory, and profit tracking.',
            selected: draft.recordingMode == 'transaction',
            accentColor: AppColors.primary,
            onTap: () {
              ref.read(signupDraftProvider.notifier).updateTrackingStep(
                    tier: draft.tier,
                    recordingMode: 'transaction',
                  );
            },
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tier 1 defaults to daily summary. Tier 2 defaults to transaction mode. You can still override the recording mode before continuing.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _SelectablePlanCard extends StatelessWidget {
  const _SelectablePlanCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.selected,
    required this.accentColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final bool selected;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected ? accentColor.withValues(alpha: 0.08) : Colors.white;
    final borderColor = selected ? accentColor : AppColors.border;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.3),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: selected ? 0.16 : 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accentColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Text(
                        subtitle,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? accentColor : Colors.transparent,
                border: Border.all(color: selected ? accentColor : AppColors.border, width: 2),
              ),
              child: selected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectableModeCard extends StatelessWidget {
  const _SelectableModeCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.accentColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected ? accentColor.withValues(alpha: 0.08) : Colors.white;
    final borderColor = selected ? accentColor : AppColors.border;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.3),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: selected ? 0.16 : 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.checklist_rounded, color: accentColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? accentColor : Colors.transparent,
                border: Border.all(color: selected ? accentColor : AppColors.border, width: 2),
              ),
              child: selected ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
