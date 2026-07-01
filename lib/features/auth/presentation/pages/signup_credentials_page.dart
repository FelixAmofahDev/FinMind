import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/features/auth/domain/entities/signup_draft.dart';
import 'package:finmind/features/auth/presentation/providers/auth_provider.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../widgets/auth_flow_scaffold.dart';
import '../widgets/auth_sample_field.dart';

class SignupCredentialsPage extends ConsumerStatefulWidget {
  const SignupCredentialsPage({super.key});

  @override
  ConsumerState<SignupCredentialsPage> createState() => _SignupCredentialsPageState();
}

class _SignupCredentialsPageState extends ConsumerState<SignupCredentialsPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(authProvider).value?.signupDraft ?? const SignupDraft();
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

    return AuthFlowScaffold(
      title: 'Create account',
      stepIndex: 3,
      stepCount: 4,
      onBack: () => Navigator.of(context).pop(),
      subtitle: 'Step 4 of 4 - we\'ll email a code to confirm it\'s you.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Your login',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          AuthSampleField(
            label: 'Email',
            value: '',
            controller: _emailController,
            readOnly: false,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
          ),
          const SizedBox(height: 15),
          AuthSampleField(
            label: 'Password',
            value: '',
            controller: _passwordController,
            obscureText: true,
            readOnly: false,
            textInputAction: TextInputAction.done,
            autofillHints: const [AutofillHints.newPassword],
          ),
          const SizedBox(height: 10),
          Text(
            'At least 8 characters. You\'ll use this to sign in next time.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          if (authState.value?.error != null) ...[
            const SizedBox(height: 14),
            Text(
              authState.value!.error!.message,
              style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600),
            ),
          ],
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Create account & send code',
            isLoading: authState.isLoading,
            onPressed: authState.isLoading
                ? null
                : () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text;

                    if (email.isEmpty || password.length < 8) {
                      return;
                    }

                    final currentDraft = ref.read(authProvider).value?.signupDraft ?? const SignupDraft();
                    ref.read(authProvider.notifier).updateSignupDraft(
                          currentDraft.copyWith(
                            email: email,
                            password: password,
                          ),
                        );

                    final created = await ref.read(authProvider.notifier).signup();

                    if (!mounted) {
                      return;
                    }

                    if (created) {
                      Navigator.of(context).pushNamed(AppRoutes.verifyEmail);
                    }
                  },
            expanded: true,
          ),
        ],
      ),
    );
  }
}
