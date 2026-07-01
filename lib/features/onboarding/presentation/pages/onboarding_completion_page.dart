import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../../../auth/domain/entities/onboarding_payload.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class OnboardingCompletionPage extends ConsumerStatefulWidget {
  const OnboardingCompletionPage({super.key});

  @override
  ConsumerState<OnboardingCompletionPage> createState() => _OnboardingCompletionPageState();
}

class _OnboardingCompletionPageState extends ConsumerState<OnboardingCompletionPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _cashController;
  late final TextEditingController _mtnController;
  late final TextEditingController _telecelController;
  late final TextEditingController _airtelController;
  late final TextEditingController _bankController;
  late final TextEditingController _stockController;
  late final TextEditingController _debtorsController;
  late final TextEditingController _creditorsController;

  @override
  void initState() {
    super.initState();
    _cashController = TextEditingController();
    _mtnController = TextEditingController();
    _telecelController = TextEditingController();
    _airtelController = TextEditingController();
    _bankController = TextEditingController();
    _stockController = TextEditingController();
    _debtorsController = TextEditingController();
    _creditorsController = TextEditingController();
  }

  @override
  void dispose() {
    _cashController.dispose();
    _mtnController.dispose();
    _telecelController.dispose();
    _airtelController.dispose();
    _bankController.dispose();
    _stockController.dispose();
    _debtorsController.dispose();
    _creditorsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Complete onboarding')),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                'Set your opening balances',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Dashboard access is blocked until onboarding is completed.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 24),
              _AmountField(label: 'Cash in hand', controller: _cashController),
              _AmountField(label: 'MTN MoMo', controller: _mtnController),
              _AmountField(label: 'Bank balance', controller: _bankController),
              _AmountField(label: 'Stock value', controller: _stockController),
              _AmountField(label: 'Debtors total', controller: _debtorsController),
              _AmountField(label: 'Creditors total', controller: _creditorsController),
              const SizedBox(height: 20),
              PrimaryButton(
                label: isLoading ? 'Submitting...' : 'Complete onboarding',
                expanded: true,
                onPressed: isLoading ? null : _completeOnboarding,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final payload = OnboardingPayload(
      cashInHand: _toDouble(_cashController.text),
      mtnMomo: _toDouble(_mtnController.text),
      bankBalance: _toDouble(_bankController.text),
      stockValue: _toDouble(_stockController.text),
      debtorsTotal: _toDouble(_debtorsController.text),
      creditorsTotal: _toDouble(_creditorsController.text),
    );

    final notifier = ref.read(authProvider.notifier);
    final session = await notifier.completeOnboarding(payload: payload);
    final authState = ref.read(authProvider);

    if (!mounted) {
      return;
    }

    if (session != null) {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
      return;
    }

    final message = authState.error?.toString() ?? 'Could not complete onboarding.';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  double _toDouble(String value) {
    return double.tryParse(value.trim()) ?? 0;
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          final parsed = double.tryParse((value ?? '').trim());
          if (parsed == null || parsed < 0) {
            return 'Enter a valid amount';
          }
          return null;
        },
      ),
    );
  }
}