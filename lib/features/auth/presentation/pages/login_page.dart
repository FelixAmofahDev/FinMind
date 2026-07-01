import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/features/auth/presentation/providers/auth_provider.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../widgets/auth_sample_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sign in'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(
                  Icons.show_chart_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Welcome back',
                style: AppTextStyles.displayLarge.copyWith(
                  fontSize: 24,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to Akosua Provisions.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
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
                autofillHints: const [AutofillHints.password],
              ),
              if (authState.value?.error != null) ...[
                const SizedBox(height: 14),
                Text(
                  authState.value!.error!.message,
                  style: TextStyle(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Forgot password?'),
                ),
              ),
              const SizedBox(height: 8),
              PrimaryButton(
                label: 'Sign in',
                isLoading: authState.isLoading,
                onPressed: authState.isLoading
                    ? null
                    : () async {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text;
                        if (email.isEmpty || password.isEmpty) {
                          return;
                        }

                        await ref
                            .read(authProvider.notifier)
                            .login(email: email, password: password);

                        if (!mounted) {
                          return;
                        }

                        final updatedState = ref.read(authProvider);
                        if (updatedState.value?.authSession != null) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.dashboard,
                            (Route<dynamic> route) =>
                                false, // This returns false for all routes, clearing the stack
                          );
                          
                        }
                      },
                expanded: true,
              ),
              const SizedBox(height: 14),
              Center(
                child: TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(AppRoutes.signupBusiness),
                  child: Text(
                    'Create an account',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ), // Added missing closing bracket for SafeArea here
    );
  }
}
