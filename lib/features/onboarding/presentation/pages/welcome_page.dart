import 'package:finmind/shared/widgets/app_logo.dart';
import 'package:flutter/material.dart';

import 'package:finmind/app/router/routes.dart';
import 'package:finmind/core/theme/text_styles.dart';
import 'package:finmind/shared/widgets/primary_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1B2A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppLogo(),                  
                  const Spacer(),
                 
                ],
              ),
              const SizedBox(height: 34),
             
              Text(
                'Know your\nmoney. Daily.',
                style: AppTextStyles.displayLarge.copyWith(
                  color: Colors.white,
                  fontSize: 30,
                  height: 1.08,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'The simple books for your shop - sales, stock, who owes you, and your profit. All in one place.',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: const Color(0xFFA8BDD6),
                  fontSize: 15.5,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, size: 15, color: Color(0xFFEF9F27)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: const Color(0xFFBCD0E6),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Create your shop account',
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.signupBusiness),
                expanded: true,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.login),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5),
                  ),
                  child: const Text('I already have an account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
