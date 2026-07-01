import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
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

  @override
  void initState() {
    super.initState();
    final draft = ref.read(signupDraftProvider);
    _emailController = TextEditingController(text: draft.email);
    _passwordController = TextEditingController(text: draft.password);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isSubmitting = authState.isLoading;

    return AuthFlowScaffold(
      title: 'Create account',
      stepIndex: 3,
      stepCount: 4,
      onBack: () => Navigator.of(context).pop(),
      subtitle: 'Step 4 of 4 - we\'ll email a code to confirm it\'s you.',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Your login',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
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
            const SizedBox(height: 15),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if ((value ?? '').length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Text(
              'At least 8 characters. You\'ll use this to sign in next time.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
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
}
