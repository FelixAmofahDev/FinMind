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

class _GateLoading extends StatefulWidget {
  const _GateLoading();

  @override
  State<_GateLoading> createState() => _GateLoadingState();
}

class _GateLoadingState extends State<_GateLoading>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _fadeController;
  late final AnimationController _shimmerController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _logoScale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _logoOpacity = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _contentFade = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge(
            [_logoController, _fadeController, _shimmerController]),
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0B3D2E), // deep green
                  const Color(0xFF0F5C4C),
                  const Color(0xFF14456B), // deep blue
                ],
                stops: [
                  0.0,
                  0.5 + 0.1 * (_shimmerController.value - 0.5),
                  1.0,
                ],
              ),
            ),
            child: Center(
              child: Opacity(
                opacity: _contentFade.value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Transform.scale(
                      scale: _logoScale.value,
                      child: Opacity(
                        opacity: _logoOpacity.value,
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF34D399), // emerald
                                Color(0xFF3B82F6), // blue
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF34D399)
                                    .withOpacity(0.35 * _logoOpacity.value),
                                blurRadius: 24,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_rounded,
                            color: Colors.white,
                            size: 44,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Wordmark
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF6EE7B7), Color(0xFF93C5FD)],
                      ).createShader(bounds),
                      child: const Text(
                        'FinMind',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Getting things ready…',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.65),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Animated progress bar
                    _ShimmerProgressBar(controller: _shimmerController),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ShimmerProgressBar extends StatelessWidget {
  const _ShimmerProgressBar({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: [
            Container(color: Colors.white.withOpacity(0.12)),
            AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final t = controller.value; // 0..1 looping
                return Align(
                  alignment: Alignment(-1 + 2 * t, 0),
                  child: FractionallySizedBox(
                    widthFactor: 0.4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF34D399), Color(0xFF3B82F6)],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}