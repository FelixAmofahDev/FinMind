class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://ai-financial-accountant-dev.up.railway.app/';
  static const String authSignup = '/api/v1/auth/signup';
  static const String authVerifyEmail = '/api/v1/auth/verify-email';
  static const String authResendVerification = '/api/v1/auth/resend-verification';
  static const String authForgotPassword = '/api/v1/auth/forgot-password';
  static const String authResetPassword = '/api/v1/auth/reset-password';
  static const String authLogin = '/api/v1/auth/login';
  static const String authRefresh = '/api/v1/auth/refresh';
  static const String onboardingComplete = '/api/v1/onboarding/complete';
  static const String sales = '/api/v1/sales';
}