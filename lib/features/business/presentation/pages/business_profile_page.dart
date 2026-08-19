import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/shared/widgets/app_card.dart';
import 'package:finmind/shared/widgets/primary_button.dart';
import 'package:finmind/shared/widgets/loading_indicator.dart';
import 'package:finmind/shared/widgets/empty_state_widget.dart';
import 'package:finmind/shared/dialogs/confirm_dialog.dart';

import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../providers/business_providers.dart';

class BusinessProfilePage extends ConsumerWidget {
  const BusinessProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(businessProfileControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Business Profile',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit profile',
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.businessSettings),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: profileState.when(
        loading: () =>
            const Center(child: LoadingIndicator(message: 'Loading profile...')),
        error: (error, _) => Center(
          child: EmptyStateWidget(
            icon: Icons.error_outline,
            title: 'Could not load business profile',
            message: error.toString(),
            action: TextButton(
              onPressed: () => ref
                  .read(businessProfileControllerProvider.notifier)
                  .refresh(),
              child: const Text('Retry'),
            ),
          ),
        ),
        data: (profile) {
          final initial =
              profile.name.isNotEmpty ? profile.name[0].toUpperCase() : 'B';

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- HERO BUSINESS CARD ---
                  _BusinessHeroHeader(
                    profile: profile,
                    initial: initial,
                    onEdit: () => Navigator.of(context)
                        .pushNamed(AppRoutes.businessSettings),
                  ),

                  const SizedBox(height: 16),

                  // --- ONBOARDING WARNING BANNER (IF INCOMPLETE) ---
                  if (!profile.onboardingComplete) ...[
                    _OnboardingWarningCard(
                      onTap: () => Navigator.of(context)
                          .pushNamed(AppRoutes.onboardingComplete),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // --- QUICK STATS ROW ---
                  Row(
                    children: [
                      Expanded(
                        child: _QuickStatTile(
                          icon: Icons.workspace_premium_rounded,
                          iconColor: const Color(0xFFE5A100),
                          label: 'Tier',
                          value: profile.tier.isEmpty ? 'Standard' : profile.tier,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickStatTile(
                          icon: profile.onboardingComplete
                              ? Icons.verified_rounded
                              : Icons.pending_actions_rounded,
                          iconColor: profile.onboardingComplete
                              ? Colors.green
                              : Colors.orange,
                          label: 'Status',
                          value: profile.onboardingComplete
                              ? 'Verified'
                              : 'Pending',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _QuickStatTile(
                          icon: Icons.mic_none_rounded,
                          iconColor: AppColors.primary,
                          label: 'Record Mode',
                          value: profile.recordingMode.isEmpty
                              ? 'Standard'
                              : profile.recordingMode,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // --- SECTION 1: GENERAL INFORMATION ---
                  _SectionHeader(title: 'Business Details'),
                  _DetailGroupCard(
                    children: [
                      _DetailListRow(
                        icon: Icons.storefront_outlined,
                        label: 'Shop Name',
                        value: profile.name.isEmpty ? 'Not set' : profile.name,
                      ),
                      _DetailListRow(
                        icon: Icons.category_outlined,
                        label: 'Business Category',
                        value: profile.type.label,
                      ),
                      _DetailListRow(
                        icon: Icons.person_outline_rounded,
                        label: 'Owner / Contact',
                        value: profile.ownerName.isEmpty
                            ? 'Not set'
                            : profile.ownerName,
                      ),
                      _DetailListRow(
                        icon: Icons.phone_outlined,
                        label: 'Phone Number',
                        value: profile.phoneNumber.isEmpty
                            ? 'Not set'
                            : profile.phoneNumber,
                        showCopy: profile.phoneNumber.isNotEmpty,
                        isLast: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- SECTION 2: LOCATION & ADDRESS ---
                  _SectionHeader(title: 'Location & Address'),
                  _DetailGroupCard(
                    children: [
                      _DetailListRow(
                        icon: Icons.map_outlined,
                        label: 'Region',
                        value: profile.locationRegion.isEmpty
                            ? 'Not set'
                            : profile.locationRegion,
                      ),
                      _DetailListRow(
                        icon: Icons.location_on_outlined,
                        label: 'District',
                        value: profile.locationDistrict.isEmpty
                            ? 'Not set'
                            : profile.locationDistrict,
                        isLast: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- SECTION 3: SYSTEM & PREFERENCES ---
                  _SectionHeader(title: 'Account Settings'),
                  _DetailGroupCard(
                    children: [
                      _DetailListRow(
                        icon: Icons.shield_outlined,
                        label: 'Subscription Tier',
                        value: profile.tier.isEmpty ? 'Standard' : profile.tier,
                      ),
                      _DetailListRow(
                        icon: Icons.tune_rounded,
                        label: 'Recording Preference',
                        value: profile.recordingMode.isEmpty
                            ? 'Manual'
                            : profile.recordingMode,
                      ),
                      _DetailListRow(
                        icon: profile.onboardingComplete
                            ? Icons.check_circle_outline_rounded
                            : Icons.help_outline_rounded,
                        label: 'Verification Status',
                        value: profile.onboardingComplete
                            ? 'Completed'
                            : 'Incomplete',
                        valueColor: profile.onboardingComplete
                            ? Colors.green
                            : Colors.orange.shade800,
                        isLast: true,
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // --- MAIN ACTIONS ---
                  PrimaryButton(
                    label: 'Edit Profile Settings',
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.businessSettings);
                    },
                    expanded: true,
                  ),

                  const SizedBox(height: 12),

                  // --- LOGOUT / SIGN OUT OPTION ---
                  TextButton(
                    onPressed: () async {
                      final confirm = await ConfirmDialog.show(
                        context,
                        title: 'Log out?',
                        message:
                            'You will be signed out of this device. You can sign back in anytime.',
                        confirmText: 'Log out',
                        destructive: true,
                      );
                      if (confirm != true || !context.mounted) {
                        return;
                      }
                      await ref.read(authProvider.notifier).signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.login,
                          (route) => false,
                        );
                      }
                    },
                    child: const Text('Log out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 18)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// =============================================================================
// SUB-COMPONENTS FOR PROFESSIONAL BUSINESS PROFILE UI
// =============================================================================

class _BusinessHeroHeader extends StatelessWidget {
  final dynamic profile;
  final String initial;
  final VoidCallback onEdit;

  const _BusinessHeroHeader({
    required this.profile,
    required this.initial,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.22),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Decorative Circle Accent
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 70,
              backgroundColor: Colors.white.withOpacity(0.06),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Business Avatar / Logo Placeholder
                    Container(
                      width: 64,
                      height: 64,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        initial,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  profile.name.isEmpty
                                      ? 'Untitled Business'
                                      : profile.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ),
                              if (profile.onboardingComplete) ...[
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.verified_rounded,
                                  color: Color(0xFF64FFDA),
                                  size: 18,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              profile.type.label,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.95),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(height: 1, color: Colors.white24),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.business_center_outlined,
                          size: 15,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Business Account',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: onEdit,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 13,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Edit Profile',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
    );
  }
}

class _OnboardingWarningCard extends StatelessWidget {
  final VoidCallback onTap;

  const _OnboardingWarningCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB300).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFE65100),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Profile Setup Incomplete',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF5D4037),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Complete onboarding to unlock full business features.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF795548),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: onTap,
            child: const Text(
              'Finish',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFFE65100),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickStatTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _QuickStatTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}

class _DetailGroupCard extends StatelessWidget {
  final List<Widget> children;

  const _DetailGroupCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _DetailListRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final bool showCopy;
  final bool isLast;

  const _DetailListRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.showCopy = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: valueColor ??
                            Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
              ),
              if (showCopy)
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  color: Colors.grey.shade500,
                  tooltip: 'Copy',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$label copied to clipboard'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 52,
            endIndent: 16,
            color: Colors.grey.withOpacity(0.12),
          ),
      ],
    );
  }
}