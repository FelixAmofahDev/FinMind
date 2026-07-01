import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
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

  static const _businessTypes = <MapEntry<String, String>>[
    MapEntry('provision_store', 'Provision store'),
    MapEntry('supermarket', 'Supermarket'),
    MapEntry('pharmacy', 'Pharmacy'),
    MapEntry('hardware', 'Hardware store'),
    MapEntry('cosmetics', 'Cosmetics shop'),
    MapEntry('phone_accessories', 'Phone accessories'),
    MapEntry('other', 'Other'),
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

    return AuthFlowScaffold(
      title: 'Create account',
      stepIndex: 0,
      stepCount: 4,
      onBack: () => Navigator.of(context).pop(),
      subtitle: 'Step 1 of 4 - the basics.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tell us about your shop',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _businessNameController,
              decoration: const InputDecoration(
                labelText: 'Shop name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if ((value ?? '').trim().isEmpty) {
                  return 'Shop name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: draft.businessType,
              decoration: const InputDecoration(
                labelText: 'What kind of business?',
                border: OutlineInputBorder(),
              ),
              items: _businessTypes
                  .map(
                    (entry) => DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                ref.read(signupDraftProvider.notifier).updateBusinessStep(
                      businessName: _businessNameController.text.trim(),
                      businessType: value,
                    );
              },
            ),
            const SizedBox(height: 14),
            Text(
              'Pick the closest - it is only used to personalise your app, not your accounting.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
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
