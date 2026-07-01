import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/features/auth/domain/entities/signup_draft.dart';
import 'package:finmind/features/auth/presentation/providers/auth_provider.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../widgets/auth_flow_scaffold.dart';
import '../widgets/auth_sample_field.dart';

class SignupLocationPage extends ConsumerStatefulWidget {
  const SignupLocationPage({super.key});

  @override
  ConsumerState<SignupLocationPage> createState() => _SignupLocationPageState();
}

class _SignupLocationPageState extends ConsumerState<SignupLocationPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  String _region = '';
  String _district = '';

  static const List<String> _regions = <String>[
    'Greater Accra',
    'Ashanti',
    'Central',
    'Western',
    'Eastern',
  ];

  static const List<String> _districts = <String>[
    'Kumasi',
    'Kumasi Metropolitan',
    'Ablekuma North',
    'Tema',
    'Cape Coast',
  ];

  @override
  void initState() {
    super.initState();
    final draft = ref.read(authProvider).value?.signupDraft ?? const SignupDraft();
    _nameController = TextEditingController(text: draft.ownerName);
    _phoneController = TextEditingController(text: draft.phoneNumber);
    _region = draft.locationRegion;
    _district = draft.locationDistrict;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
          AuthSampleField(
            label: 'Your name',
            value: '',
            controller: _nameController,
            readOnly: false,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 15),
          AuthSampleField(
            label: 'Phone number',
            value: '',
            controller: _phoneController,
            readOnly: false,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 15),
          _DropdownLikeField(
            label: 'Region',
            value: _region,
            placeholder: 'Select region',
            onTap: () => _pickValue(
              title: 'Select region',
              values: _regions,
              onSelected: (value) => setState(() => _region = value),
            ),
          ),
          const SizedBox(height: 15),
          _DropdownLikeField(
            label: 'District',
            value: _district,
            placeholder: 'Select district',
            onTap: () => _pickValue(
              title: 'Select district',
              values: _districts,
              onSelected: (value) => setState(() => _district = value),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Continue',
            onPressed: () {
              ref.read(authProvider.notifier).updateSignupDraft(
                    (ref.read(authProvider).value?.signupDraft ?? const SignupDraft()).copyWith(
                      ownerName: _nameController.text.trim(),
                      phoneNumber: _phoneController.text.trim(),
                      locationRegion: _region,
                      locationDistrict: _district,
                    ),
                  );
              Navigator.of(context).pushNamed(AppRoutes.signupTracking);
            },
            expanded: true,
          ),
        ],
      ),
    );
  }

  Future<void> _pickValue({
    required String title,
    required List<String> values,
    required ValueChanged<String> onSelected,
  }) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: 320,
                  child: ListView.separated(
                    itemCount: values.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final value = values[index];
                      return ListTile(
                        title: Text(value),
                        onTap: () => Navigator.of(context).pop(value),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (selected != null) {
      onSelected(selected);
    }
  }
}

class _DropdownLikeField extends StatelessWidget {
  const _DropdownLikeField({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  final String label;
  final String value;
  final String placeholder;
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
                    value.isEmpty ? placeholder : value,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: value.isEmpty ? AppColors.textSecondary : AppColors.textPrimary,
                    ),
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
