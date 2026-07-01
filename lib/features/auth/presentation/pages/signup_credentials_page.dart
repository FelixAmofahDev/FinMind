import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../providers/auth_provider.dart';
import '../widgets/auth_flow_scaffold.dart';

class SignupCredentialsPage extends ConsumerStatefulWidget {
  const SignupCredentialsPage({super.key});

  @override
  ConsumerState<SignupCredentialsPage> createState() => _SignupCredentialsPageState();
}

class _SignupCredentialsPageState extends ConsumerState<SignupCredentialsPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(signupDraftProvider);
    _emailController = TextEditingController(text: draft.email);
    _passwordController = TextEditingController(text: draft.password);
    _confirmPasswordController = TextEditingController(text: draft.password);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isSubmitting = authState.isLoading;
    final draft = ref.watch(signupDraftProvider);

    return AuthFlowScaffold(
      title: 'Create account',
      stepIndex: 3,
      stepCount: 4,
      onBack: () => Navigator.of(context).pop(),
      subtitle: 'Step 4 of 4 · secure the account and finish signup.',
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
                    child: const Icon(Icons.lock_rounded, color: AppColors.secondary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Set secure login details for the business account.',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'We’ll use this email to send your verification code. The password should be memorable but strong.',
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
                  Text(
                    'Account summary',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _SummaryLine(label: 'Business', value: draft.businessName.isEmpty ? 'Unnamed shop' : draft.businessName),
                  _SummaryLine(label: 'Owner', value: draft.ownerName.isEmpty ? 'Not set' : draft.ownerName),
                  _SummaryLine(label: 'Location', value: draft.locationRegion.isEmpty ? 'Not set' : '${draft.locationRegion}, ${draft.locationDistrict}'),
                  _SummaryLine(label: 'Tracking', value: draft.tier == 'tier1' ? 'Tier 1 · Daily totals' : 'Tier 2 · POS transactions'),
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
                  _FieldLabel(label: 'Email address', helper: 'This receives the verification code.'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _fieldDecoration(hintText: 'e.g. akosua@gmail.com'),
                    validator: (value) {
                      final email = (value ?? '').trim();
                      if (email.isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                      if (!emailRegex.hasMatch(email)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel(label: 'Password', helper: 'Use at least 8 characters and mix letters with numbers.'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _fieldDecoration(hintText: 'Create a password'),
                    validator: (value) {
                      if ((value ?? '').length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _FieldLabel(label: 'Confirm password', helper: 'Re-enter the same password to avoid mistakes.'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: _fieldDecoration(hintText: 'Confirm your password'),
                    validator: (value) {
                      if ((value ?? '').isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
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
                      'At least 8 characters. You’ll use this password to sign in next time, so keep it secure.',
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
              label: isSubmitting ? 'Creating account...' : 'Create account & send code',
              onPressed: isSubmitting ? null : _submitSignup,
              expanded: true,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final notifier = ref.read(authProvider.notifier);
    final draftNotifier = ref.read(signupDraftProvider.notifier);
    final draft = ref.read(signupDraftProvider).copyWith(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    draftNotifier.updateCredentialsStep(
      email: draft.email,
      password: draft.password,
    );

    final verificationEmail = await notifier.signup(draft: draft);
    final authState = ref.read(authProvider);
    if (!mounted) {
      return;
    }

    if (verificationEmail != null) {
      draftNotifier.updateCredentialsStep(
        email: verificationEmail,
        password: draft.password,
      );
      Navigator.of(context).pushNamed(AppRoutes.verifyEmail);
      return;
    }

    final message = notifier.toUserMessage(
      authState.error,
      fallback: 'Could not create account. Please try again.',
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 12,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
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
