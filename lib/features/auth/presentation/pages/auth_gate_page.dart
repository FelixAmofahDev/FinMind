import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../products/presentation/pages/products_page.dart';
import '../../../onboarding/presentation/pages/onboarding_completion_page.dart';
import '../../../onboarding/presentation/pages/welcome_page.dart';
import 'email_verification_page.dart';
import 'package:finmind/features/dashboard/presentation/pages/dashboard_page.dart';
import '../providers/auth_provider.dart';

class AuthGatePage extends ConsumerWidget {
  const AuthGatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigationState = ref.watch(authNavigationStateProvider);
    final session = ref.watch(authProvider).asData?.value;

    return navigationState.when(
      loading: () => const _GateLoading(),
      error: (error, stackTrace) => const WelcomePage(),
      data: (state) {
        switch (state) {
          case AuthNavigationState.unauthenticated:
            return const WelcomePage();
          case AuthNavigationState.needsEmailVerification:
            return EmailVerificationPage(initialEmail: session?.user.email);
          case AuthNavigationState.needsProductsSetup:
            return const ProductsPage(onboardingFlow: true);
          case AuthNavigationState.needsOnboarding:
            return const OnboardingCompletionPage();
          case AuthNavigationState.authenticated:
            return const DashboardPage();
        }
      },
    );
  }
}

class _GateLoading extends StatelessWidget {
  const _GateLoading();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}