import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/shared/widgets/app_card.dart';
import 'package:finmind/shared/widgets/primary_button.dart';
import 'package:finmind/shared/widgets/loading_indicator.dart';
import 'package:finmind/shared/widgets/empty_state_widget.dart';

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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit profile',
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.businessSettings),
          ),
          const SizedBox(width: 4),
        ],
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
          final initial = profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'B';

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hero header
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.blue,
                          AppColors.blue.withValues(alpha: 0.82),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26185FA5),
                          blurRadius: 28,
                          offset: Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                              ),
                              child: Text(
                                initial,
                                style: AppTextStyles.titleLarge.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile.name.isEmpty ? 'Untitled Business' : profile.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.titleLarge.copyWith(
                                      color: Colors.white,
                                      fontSize: 19,
                                      height: 1.25,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.storefront_rounded,
                                          size: 14, color: Colors.white.withValues(alpha: 0.85)),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          profile.type.label,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            color: Colors.white.withValues(alpha: 0.88),
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            _HeaderBadge(
                              icon: Icons.workspace_premium_rounded,
                              label: profile.tier.isEmpty ? 'Standard' : profile.tier,
                            ),
                            const SizedBox(width: 8),
                            _HeaderBadge(
                              icon: profile.onboardingComplete
                                  ? Icons.verified_rounded
                                  : Icons.hourglass_bottom_rounded,
                              label: profile.onboardingComplete ? 'Verified' : 'Setup pending',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  _SectionLabel('Business information'),
                  _DetailCard(
                    children: [
                      _DetailRow(
                        icon: Icons.storefront_outlined,
                        label: 'Shop name',
                        value: profile.name.isEmpty ? 'Not set' : profile.name,
                      ),
                      _DetailRow(
                        icon: Icons.category_outlined,
                        label: 'Business type',
                        value: profile.type.label,
                      ),
                      _DetailRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Owner name',
                        value: profile.ownerName.isEmpty ? 'Not set' : profile.ownerName,
                      ),
                      _DetailRow(
                        icon: Icons.call_outlined,
                        label: 'Phone',
                        value: profile.phoneNumber.isEmpty ? 'Not set' : profile.phoneNumber,
                        isLast: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _SectionLabel('Location'),
                  _DetailCard(
                    children: [
                      _DetailRow(
                        icon: Icons.map_outlined,
                        label: 'Region',
                        value: profile.locationRegion.isEmpty ? 'Not set' : profile.locationRegion,
                      ),
                      _DetailRow(
                        icon: Icons.location_on_outlined,
                        label: 'District',
                        value: profile.locationDistrict.isEmpty ? 'Not set' : profile.locationDistrict,
                        isLast: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _SectionLabel('Account details'),
                  _DetailCard(
                    children: [
                      _DetailRow(
                        icon: Icons.workspace_premium_outlined,
                        label: 'Tier',
                        value: profile.tier.isEmpty ? '—' : profile.tier,
                      ),
                      _DetailRow(
                        icon: Icons.mic_none_rounded,
                        label: 'Recording mode',
                        value: profile.recordingMode.isEmpty ? '—' : profile.recordingMode,
                      ),
                      _DetailRow(
                        icon: profile.onboardingComplete
                            ? Icons.check_circle_outline_rounded
                            : Icons.error_outline_rounded,
                        label: 'Onboarding',
                        value: profile.onboardingComplete ? 'Complete' : 'Incomplete',
                        valueColor: profile.onboardingComplete ? Colors.green : null,
                        isLast: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),
                  PrimaryButton(
  label: 'Update profile',
  icon: const Icon(Icons.edit_outlined),
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

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 17, color: AppColors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: AppColors.textSecondary.withValues(alpha: 0.08)),
      ],
    );
  }
}