import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

import '../providers/auth_provider.dart';

class EmailVerificationPage extends ConsumerStatefulWidget {
  const EmailVerificationPage({
    super.key,
    this.initialEmail,
  });

  final String? initialEmail;

  @override
  ConsumerState<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends ConsumerState<EmailVerificationPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    final signupEmail = ref.read(signupDraftProvider).email;
    _emailController = TextEditingController(
      text: widget.initialEmail ?? (signupEmail.isEmpty ? 'akosua@gmail.com' : signupEmail),
    );
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    final resendCooldown = ref.watch(verificationResendCooldownProvider);
    final canResend = resendCooldown == 0;
    final resendLabel = canResend ? 'Resend code' : 'Resend code in ${_formatCooldown(resendCooldown)}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Verify email'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(Icons.mail_outline_rounded, color: AppColors.primary),
              ),
              const SizedBox(height: 20),
              Text(
                'Check your email',
                style: AppTextStyles.displayLarge.copyWith(
                  fontSize: 23,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We sent a 6-digit code to',
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 26),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Verification code',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
              ),
              const SizedBox(height: 26),
              PrimaryButton(
                label: isLoading ? 'Verifying...' : 'Verify & continue',
                onPressed: isLoading ? null : _verify,
                expanded: true,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: canResend ? _resendCode : null,
                  child: Text.rich(
                    TextSpan(
                      text: "Didn't get it? ",
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      children: [
                        TextSpan(
                          text: resendLabel,
                          style: TextStyle(
                            color: canResend ? AppColors.primary : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verify() async {
    final email = _emailController.text.trim();
    final code = _codeController.text.trim();
    if (email.isEmpty || code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid email and 6-digit verification code.')),
      );
      return;
    }

    final notifier = ref.read(authProvider.notifier);
    final session = await notifier.verifyEmail(
      email: email,
      code: code,
    );
    final authState = ref.read(authProvider);

    if (!mounted) {
      return;
    }

    if (session != null) {
      ref.read(signupDraftProvider.notifier).reset();
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.authGate, (_) => false);
      return;
    }

    final message = notifier.toUserMessage(
      authState.error,
      fallback: 'Verification failed. Please check your code and try again.',
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _resendCode() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your email before requesting a new code.')),
      );
      return;
    }

    final notifier = ref.read(authProvider.notifier);
    try {
      await notifier.resendVerification(email: email);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('If the account exists, a new code has been sent.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      final message = notifier.toUserMessage(
        error,
        fallback: 'Unable to resend the code right now. Please try again.',
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  String _formatCooldown(int seconds) {
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return '$minutes:${remainder.toString().padLeft(2, '0')}';
  }
}
