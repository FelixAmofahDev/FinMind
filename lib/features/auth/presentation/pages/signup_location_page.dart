import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth_flow_scaffold.dart';

class SignupLocationPage extends ConsumerStatefulWidget {
  const SignupLocationPage({super.key});

  @override
  ConsumerState<SignupLocationPage> createState() => _SignupLocationPageState();
}

class _SignupLocationPageState extends ConsumerState<SignupLocationPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _ownerNameController;
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _regionController;
  late final TextEditingController _districtController;

  static const List<String> _regions = <String>[
    'Ahafo',
    'Ashanti',
    'Bono',
    'Bono East',
    'Central',
    'Eastern',
    'Greater Accra',
    'North East',
    'Northern',
    'Oti',
    'Savannah',
    'Upper East',
    'Upper West',
    'Volta',
    'Western',
    'Western North',
  ];

  @override
  void initState() {
    super.initState();
    final draft = ref.read(signupDraftProvider);
    _ownerNameController = TextEditingController(text: draft.ownerName);
    _phoneNumberController = TextEditingController(text: draft.phoneNumber);
    _regionController = TextEditingController(text: draft.locationRegion);
    _districtController = TextEditingController(text: draft.locationDistrict);
  }

  @override
  void dispose() {
    _ownerNameController.dispose();
    _phoneNumberController.dispose();
    _regionController.dispose();
    _districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthFlowScaffold(
      title: 'Create account',
      stepIndex: 1,
      stepCount: 4,
      onBack: () => Navigator.of(context).pop(),
      subtitle: 'Step 2 of 4 · owner profile and operating region.',
      child: Form(
        key: _formKey,
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
                      color: AppColors.secondary.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.place_rounded, color: AppColors.secondary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tell us who is behind the business and where it operates.',
                          style: AppTextStyles.titleLarge.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'These details keep the account accurate and help FinMind tailor the experience to your market.',
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
                  _FieldLabel(
                    label: 'Owner name',
                    helper: 'The person responsible for the account.',
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _ownerNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _fieldDecoration(hintText: 'e.g. Akosua Mensah'),
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Owner name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel(label: 'Phone number', helper: 'A number we can associate with the business.'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: _fieldDecoration(hintText: 'e.g. 024 412 3456'),
                    validator: (value) {
                      final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
                      if (digits.length < 10) {
                        return 'Phone number must be at least 10 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel(label: 'Region', helper: 'Select the Ghana region where you trade.'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _regionController.text.isEmpty ? null : _regionController.text,
                    decoration: _fieldDecoration(hintText: 'Select region'),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    items: _regions
                        .map(
                          (region) => DropdownMenuItem<String>(
                            value: region,
                            child: Text(region),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _regionController.text = value;
                      });
                      ref.read(signupDraftProvider.notifier).updateLocationStep(
                            ownerName: _ownerNameController.text.trim(),
                            phoneNumber: _phoneNumberController.text.trim(),
                            locationRegion: value,
                            locationDistrict: _districtController.text.trim(),
                          );
                    },
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Region is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel(label: 'District', helper: 'A district or locality name for the shop.'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _districtController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _fieldDecoration(hintText: 'e.g. Ablekuma North'),
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'District is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                      'The region list follows the supported Ghana regions in the product flow. District can be refined later if needed.',
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

    ref.read(signupDraftProvider.notifier).updateLocationStep(
          ownerName: _ownerNameController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          locationRegion: _regionController.text.trim(),
          locationDistrict: _districtController.text.trim(),
        );
    Navigator.of(context).pushNamed(AppRoutes.signupTracking);
  }

  InputDecoration _fieldDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
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
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({
    required this.label,
    required this.helper,
  });

  final String label;
  final String helper;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          helper,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
