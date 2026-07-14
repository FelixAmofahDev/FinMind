import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth_flow_scaffold.dart';

class SignupBusinessPage extends ConsumerStatefulWidget {
  const SignupBusinessPage({super.key});

  @override
  ConsumerState<SignupBusinessPage> createState() => _SignupBusinessPageState();
}

class _SignupBusinessPageState extends ConsumerState<SignupBusinessPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _businessNameController;

  static const _businessTypes = <_BusinessTypeOption>[
    _BusinessTypeOption(
      value: 'provision_store',
      title: 'Provision store',
      subtitle: 'Retail essentials, fast stock rotation.',
      icon: Icons.storefront_rounded,
    ),
    _BusinessTypeOption(
      value: 'supermarket',
      title: 'Supermarket',
      subtitle: 'Larger catalogue, higher volume.',
      icon: Icons.shopping_bag_rounded,
    ),
    _BusinessTypeOption(
      value: 'pharmacy',
      title: 'Pharmacy',
      subtitle: 'Controlled inventory and compliance.',
      icon: Icons.local_pharmacy_rounded,
    ),
    _BusinessTypeOption(
      value: 'hardware',
      title: 'Hardware store',
      subtitle: 'Tools, building materials and supplies.',
      icon: Icons.handyman_rounded,
    ),
    _BusinessTypeOption(
      value: 'cosmetics',
      title: 'Cosmetics shop',
      subtitle: 'Beauty products and personal care.',
      icon: Icons.face_retouching_natural_rounded,
    ),
    _BusinessTypeOption(
      value: 'phone_accessories',
      title: 'Phone accessories',
      subtitle: 'Cases, chargers and tech add-ons.',
      icon: Icons.phonelink_rounded,
    ),
    _BusinessTypeOption(
      value: 'other',
      title: 'Other',
      subtitle: 'A different shop model.',
      icon: Icons.grid_view_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    final draft = ref.read(signupDraftProvider);
    _businessNameController = TextEditingController(text: draft.businessName);
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(signupDraftProvider);
    final selectedType = _businessTypes.firstWhere(
      (type) => type.value == draft.businessType,
      orElse: () => _businessTypes.first,
    );

    return AuthFlowScaffold(
      title: 'Create account',
      subtitle: 'Step 1 of 4 · define the business identity.',
      stepIndex: 0,
      stepCount: 4,
      onBack: () => Navigator.of(context).pop(),
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
                          'Build a business profile that feels professional from the first screen.',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'These details shape your account, reports, and the language the app uses for your shop.',
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
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Shop name',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _businessNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'e.g. Akosua Provisions',
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
                      ),
                    ),
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Shop name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Text(
                        'Business type',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Tap to change',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GridView(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.25,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _businessTypes
                        .map(
                          (option) => _BusinessTypeCard(
                            option: option,
                            selected: option.value == selectedType.value,
                            onTap: () {
                              ref.read(signupDraftProvider.notifier).updateBusinessStep(
                                    businessName: _businessNameController.text.trim(),
                                    businessType: option.value,
                                  );
                            },
                          ),
                        )
                        .toList(),
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
                            'The business type only helps FinMind personalize the account setup. It does not restrict accounting rules.',
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
                ],
              ),
            ),
            const SizedBox(height: 22),
            PrimaryButton(
              label: 'Continue',
              onPressed: _continue,
              expanded: true,
            ),
          ],
        ),
      ),
    );
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final draft = ref.read(signupDraftProvider);
    ref.read(signupDraftProvider.notifier).updateBusinessStep(
          businessName: _businessNameController.text.trim(),
          businessType: draft.businessType,
        );
    Navigator.of(context).pushNamed(AppRoutes.signupLocation);
  }
}

class _BusinessTypeOption {
  const _BusinessTypeOption({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String value;
  final String title;
  final String subtitle;
  final IconData icon;
}

class _BusinessTypeCard extends StatelessWidget {
  const _BusinessTypeCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _BusinessTypeOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? AppColors.primary : AppColors.border;
    final backgroundColor = selected ? AppColors.primary.withValues(alpha: 0.06) : Colors.white;

    return InkWell(
       onTap: onTap,
       borderRadius: BorderRadius.circular(18),
       child: AnimatedContainer(
         duration: const Duration(milliseconds: 160),
         width: (MediaQuery.of(context).size.width - 20 - 20 - 18) / 2,
         padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
         decoration: BoxDecoration(
           color: backgroundColor,
           borderRadius: BorderRadius.circular(18),
           border: Border.all(color: borderColor, width: 1.3),
           boxShadow: selected
               ? const [
                   BoxShadow(
                     color: Color(0x12000000),
                     blurRadius: 18,
                     offset: Offset(0, 8),
                   ),
                 ]
               : null,
         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(
               children: [
                 Container(
                   width: 30,
                   height: 30,
                   decoration: BoxDecoration(
                     color: AppColors.primary.withValues(alpha: selected ? 0.14 : 0.09),
                     borderRadius: BorderRadius.circular(10),
                   ),
                   child: Icon(option.icon, color: AppColors.primary, size: 17),
                 ),
                 const Spacer(),
                 Container(
                   width: 18,
                   height: 18,
                   decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     color: selected ? AppColors.primary : Colors.transparent,
                     border: Border.all(color: selected ? AppColors.primary : AppColors.border, width: 1.8),
                   ),
                   child: selected ? Icon(Icons.check, size: 10, color: Colors.white) : null,
                 ),
               ],
             ),
             const SizedBox(height: 10),
             Text(
               option.title,
               style: AppTextStyles.bodyLarge.copyWith(
                 fontWeight: FontWeight.w700,
                 color: AppColors.textPrimary,
                 fontSize: 13.5,
               ),
             ),
             const SizedBox(height: 3),
             Expanded(
               child: Text(
                 option.subtitle,
                 style: AppTextStyles.bodyMedium.copyWith(
                   fontSize: 11,
                   color: AppColors.textSecondary,
                   height: 1.3,
                 ),
               ),
             ),
           ],
         ),
       ),
     );
  }
}
