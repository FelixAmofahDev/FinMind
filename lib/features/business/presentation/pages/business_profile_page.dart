import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/shared/widgets/app_card.dart';
import 'package:finmind/shared/widgets/primary_button.dart';
import 'package:finmind/shared/widgets/loading_indicator.dart';
import 'package:finmind/shared/widgets/empty_state_widget.dart';

import '../../domain/entities/business_profile.dart';
import '../providers/business_providers.dart';

class BusinessProfilePage extends ConsumerWidget {
  const BusinessProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(businessProfileControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Business profile'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: profileState.when(
        loading: () => const Center(child: LoadingIndicator(message: 'Loading profile...')),
        error: (error, _) => Center(
          child: EmptyStateWidget(
            icon: Icons.error_outline,
            title: 'Could not load business profile',
            message: error.toString(),
            action: TextButton(
              onPressed: () => ref.read(businessProfileControllerProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ),
        ),
        data: (profile) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.blue,
                          AppColors.blue.withValues(alpha: 0.86),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A185FA5),
                          blurRadius: 24,
                          offset: Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.badge_rounded, color: Colors.white),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.name.isEmpty ? 'Untitled Business' : profile.name,
                                style: AppTextStyles.titleLarge.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                profile.type.label,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white.withValues(alpha: 0.84),
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
                  _DetailCard(
                    title: 'Business information',
                    children: [
                      _DetailRow(label: 'Shop name', value: profile.name.isEmpty ? 'Not set' : profile.name),
                      _DetailRow(label: 'Business type', value: profile.type.label),
                      _DetailRow(label: 'Owner name', value: profile.ownerName.isEmpty ? 'Not set' : profile.ownerName),
                      _DetailRow(label: 'Phone', value: profile.phoneNumber.isEmpty ? 'Not set' : profile.phoneNumber),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _DetailCard(
                    title: 'Location',
                    children: [
                      _DetailRow(label: 'Region', value: profile.locationRegion.isEmpty ? 'Not set' : profile.locationRegion),
                      _DetailRow(label: 'District', value: profile.locationDistrict.isEmpty ? 'Not set' : profile.locationDistrict),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _DetailCard(
                    title: 'Account details',
                    children: [
                      _DetailRow(label: 'Tier', value: profile.tier.isEmpty ? '—' : profile.tier),
                      _DetailRow(label: 'Recording mode', value: profile.recordingMode.isEmpty ? '—' : profile.recordingMode),
                      _DetailRow(
                        label: 'Onboarding',
                        value: profile.onboardingComplete ? 'Complete' : 'Incomplete',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: 'Update profile',
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.businessSettings);
                    },
                    expanded: true,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
