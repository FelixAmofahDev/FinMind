class AppRoutes {
  const AppRoutes._();

  static const String authGate = '/';
  static const String home = authGate;
  static const String welcome = '/welcome';
  static const String signupBusiness = '/auth/signup/business';
  static const String signupLocation = '/auth/signup/location';
  static const String signupTracking = '/auth/signup/tracking';
  static const String signupCredentials = '/auth/signup/credentials';
  static const String verifyEmail = '/auth/verify-email';
  static const String login = '/auth/login';
  static const String onboardingComplete = '/onboarding/complete';
  static const String dashboard = '/dashboard';
}