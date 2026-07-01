import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/features/auth/presentation/providers/auth_provider.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

class EmailVerificationPage extends ConsumerStatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  ConsumerState<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends ConsumerState<EmailVerificationPage> {
  late final List<TextEditingController> _otpControllers;
  late final List<FocusNode> _otpFocusNodes;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(6, (_) => TextEditingController());
    _otpFocusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _otpControllers.map((controller) => controller.text.trim()).join();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final email = authState.value?.signupDraft.email.isNotEmpty == true
        ? authState.value!.signupDraft.email
        : authState.value?.authSession?.user.email ?? '';
    
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
                'We sent a 6-digit code to\n$email',
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 26),
              _buildOtpFields(context),
              const SizedBox(height: 26),
              if (authState.value?.error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    authState.value!.error!.message,
                    style: TextStyle(color: AppColors.danger),
                  ),
                ),
              if (authState.value?.error != null) const SizedBox(height: 16),
              PrimaryButton(
                label: 'Verify & continue',
                isLoading: authState.isLoading,
                onPressed: authState.isLoading
                    ? null
                    : () async {
                        final code = _otpCode;
                        if (code.length == 6 && email.isNotEmpty) {
                          await ref.read(authProvider.notifier).verifyEmail(
                                email: email,
                                code: code,
                              );
                          if (!mounted) {
                            return;
                          }

                          final updatedState = ref.read(authProvider);
                          if (updatedState.value?.authSession != null) {
                            Navigator.of(context).pushNamed(AppRoutes.dashboard);
                          }
                        }
                      },
                expanded: true,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: authState.isLoading || email.isEmpty
                      ? null
                      : () async {
                          await ref.read(authProvider.notifier).resendVerification(email: email);
                        },
                  child: Text.rich(
                    TextSpan(
                      text: "Didn't get it? ",
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      children: const [
                        TextSpan(
                          text: 'Resend code',
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(text: ' · '),
                        TextSpan(text: '0:42', style: TextStyle(color: AppColors.textSecondary)),
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

  Widget _buildOtpFields(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          width: 44,
          height: 54,
          margin: const EdgeInsets.symmetric(horizontal: 4.5),
          child: TextField(
            controller: _otpControllers[index],
            focusNode: _otpFocusNodes[index],
            onChanged: (value) {
              if (value.length == 1 && index < 5) {
                FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
              }
            },
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
            keyboardType: TextInputType.number,
            textInputAction: index == 5 ? TextInputAction.done : TextInputAction.next,
          ),
        );
      }),
    );
  }
}