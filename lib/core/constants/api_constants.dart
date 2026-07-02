class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://ai-financial-accountant-dev.up.railway.app/';
  static const String signup = '/api/v1/auth/signup';
  static const String login = '/api/v1/auth/login';
  static const String verifyEmail = '/api/v1/auth/verify-email';
  static const String resendVerification = '/api/v1/auth/resend-verification';
  static const String refreshToken = '/api/v1/auth/refresh';
  static const String completeOnboarding = '/api/v1/onboarding/complete';
  static const String products = '/api/v1/products';
  static const String sales = '/sales';
}