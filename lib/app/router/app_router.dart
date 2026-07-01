import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/auth_gate_page.dart';
import '../../features/auth/presentation/pages/email_verification_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_business_page.dart';
import '../../features/auth/presentation/pages/signup_credentials_page.dart';
import '../../features/auth/presentation/pages/signup_location_page.dart';
import '../../features/auth/presentation/pages/signup_tracking_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_completion_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import 'routes.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.authGate:
        return _buildRoute(settings, const AuthGatePage());
      case AppRoutes.welcome:
        return _buildRoute(settings, const WelcomePage());
      case AppRoutes.signupBusiness:
        return _buildRoute(settings, const SignupBusinessPage());
      case AppRoutes.signupLocation:
        return _buildRoute(settings, const SignupLocationPage());
      case AppRoutes.signupTracking:
        return _buildRoute(settings, const SignupTrackingPage());
      case AppRoutes.signupCredentials:
        return _buildRoute(settings, const SignupCredentialsPage());
      case AppRoutes.verifyEmail:
        return _buildRoute(settings, const EmailVerificationPage());
      case AppRoutes.login:
        return _buildRoute(settings, const LoginPage());
      case AppRoutes.onboardingComplete:
        return _buildRoute(settings, const OnboardingCompletionPage());
      case AppRoutes.dashboard:
        return _buildRoute(settings, const DashboardPage());
      default:
        return _buildRoute(settings, const _NotFoundPage());
    }
  }

  static MaterialPageRoute<dynamic> _buildRoute(
    RouteSettings settings,
    Widget child,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => child,
    );
  }
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: const Center(
        child: Text('The requested route does not exist.'),
      ),
    );
  }
}