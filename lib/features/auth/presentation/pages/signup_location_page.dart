import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
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
      subtitle: 'Step 2 of 4 - owner and location.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'You & where you trade',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ownerNameController,
              decoration: const InputDecoration(
                labelText: 'Your name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if ((value ?? '').trim().isEmpty) {
                  return 'Owner name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
                if (digits.length < 10) {
                  return 'Phone number must be at least 10 digits';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _regionController,
              decoration: const InputDecoration(
                labelText: 'Region',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if ((value ?? '').trim().isEmpty) {
                  return 'Region is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _districtController,
              decoration: const InputDecoration(
                labelText: 'District',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if ((value ?? '').trim().isEmpty) {
                  return 'District is required';
                }
                return null;
              },
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

    ref.read(signupDraftProvider.notifier).updateLocationStep(
          ownerName: _ownerNameController.text.trim(),
          phoneNumber: _phoneNumberController.text.trim(),
          locationRegion: _regionController.text.trim(),
          locationDistrict: _districtController.text.trim(),
        );
    Navigator.of(context).pushNamed(AppRoutes.signupTracking);
  }
}
