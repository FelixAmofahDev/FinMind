import 'package:flutter/material.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/colors.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                'We sent a 6-digit code to\nakosua@gmail.com',
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _OtpBox(value: '4', active: true),
                  SizedBox(width: 9),
                  _OtpBox(value: '8', active: true),
                  SizedBox(width: 9),
                  _OtpBox(value: '3', active: true),
                  SizedBox(width: 9),
                  _OtpBox(value: '9', active: true),
                  SizedBox(width: 9),
                  _OtpBox(value: '_'),
                  SizedBox(width: 9),
                  _OtpBox(value: '_'),
                ],
              ),
              const SizedBox(height: 26),
              PrimaryButton(
                label: 'Verify & continue',
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.dashboard),
                expanded: true,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              const SizedBox(height: 16),
              Center(
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
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  const _OtpBox({
    required this.value,
    this.active = false,
  });

  final String value;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 54,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: active ? AppColors.primary : AppColors.border, width: 1.5),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w800,
          color: active ? AppColors.primary : AppColors.textPrimary,
        ),
      ),
    );
  }
}
