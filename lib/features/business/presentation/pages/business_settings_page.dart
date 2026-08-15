import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/shared/widgets/app_text_field.dart';
import 'package:finmind/shared/widgets/primary_button.dart';
import 'package:finmind/shared/dialogs/success_dialog.dart';
import 'package:finmind/shared/widgets/loading_indicator.dart';
import 'package:finmind/shared/widgets/empty_state_widget.dart';

import '../../domain/entities/business_type.dart';
import '../widgets/business_type_selector.dart';
import '../providers/business_providers.dart';

class BusinessSettingsPage extends ConsumerStatefulWidget {
  const BusinessSettingsPage({super.key});

  @override
  ConsumerState<BusinessSettingsPage> createState() => _BusinessSettingsPageState();
}

class _BusinessSettingsPageState extends ConsumerState<BusinessSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ownerNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _regionController;
  late final TextEditingController _districtController;

  BusinessType _selectedType = BusinessType.other;

  static const _businessTypeOptions = <BusinessTypeOption>[
    BusinessTypeOption(
      type: BusinessType.provisionStore,
      title: 'Provision store',
      subtitle: 'Retail essentials, fast stock rotation.',
      icon: Icons.storefront_rounded,
    ),
    BusinessTypeOption(
      type: BusinessType.supermarket,
      title: 'Supermarket',
      subtitle: 'Larger catalogue, higher volume.',
      icon: Icons.shopping_bag_rounded,
    ),
    BusinessTypeOption(
      type: BusinessType.pharmacy,
      title: 'Pharmacy',
      subtitle: 'Controlled inventory and compliance.',
      icon: Icons.local_pharmacy_rounded,
    ),
    BusinessTypeOption(
      type: BusinessType.hardware,
      title: 'Hardware store',
      subtitle: 'Tools, building materials and supplies.',
      icon: Icons.handyman_rounded,
    ),
    BusinessTypeOption(
      type: BusinessType.cosmetics,
      title: 'Cosmetics shop',
      subtitle: 'Beauty products and personal care.',
      icon: Icons.face_retouching_natural_rounded,
    ),
    BusinessTypeOption(
      type: BusinessType.phoneAccessories,
      title: 'Phone accessories',
      subtitle: 'Cases, chargers and tech add-ons.',
      icon: Icons.phonelink_rounded,
    ),
    BusinessTypeOption(
      type: BusinessType.other,
      title: 'Other',
      subtitle: 'A different shop model.',
      icon: Icons.grid_view_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    final profile = ref.read(businessProfileControllerProvider).value;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _ownerNameController = TextEditingController(text: profile?.ownerName ?? '');
    _phoneController = TextEditingController(text: profile?.phoneNumber ?? '');
    _regionController = TextEditingController(text: profile?.locationRegion ?? '');
    _districtController = TextEditingController(text: profile?.locationDistrict ?? '');
    _selectedType = profile?.type ?? BusinessType.other;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    _regionController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref.read(businessProfileControllerProvider.notifier).updateProfile(
          name: _nameController.text.trim(),
          type: _selectedType,
          ownerName: _ownerNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          locationRegion: _regionController.text.trim(),
          locationDistrict: _districtController.text.trim(),
        );

    if (mounted) {
      SuccessDialog.show(
        context,
        message: 'Business profile updated successfully.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(businessProfileControllerProvider);

    ref.listen(businessProfileControllerProvider, (prev, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Business settings'),
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.86),
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
                    AppTextField(
                      controller: _nameController,
                      labelText: 'Shop name',
                      hintText: 'e.g. Akosua Provisions',
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'Shop name is required';
                        }
                        if ((value ?? '').trim().length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _ownerNameController,
                      labelText: 'Owner name',
                      hintText: 'e.g. Akosua Mensah',
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'Owner name is required';
                        }
                        if ((value ?? '').trim().length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _phoneController,
                      labelText: 'Phone number',
                      hintText: 'e.g. 0244123456',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'Phone number is required';
                        }
                        if ((value ?? '').trim().length < 9) {
                          return 'Phone number must be at least 9 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Business type',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    BusinessTypeSelector(
                      options: _businessTypeOptions,
                      selected: _selectedType,
                      onSelected: (type) {
                        setState(() => _selectedType = type);
                      },
                    ),
                    const SizedBox(height: 18),
                    AppTextField(
                      controller: _regionController,
                      labelText: 'Region',
                      hintText: 'e.g. Greater Accra',
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'Region is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _districtController,
                      labelText: 'District',
                      hintText: 'e.g. Ablekuma North',
                      validator: (value) {
                        if ((value ?? '').trim().isEmpty) {
                          return 'District is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'Save changes',
                      onPressed: _save,
                      expanded: true,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
