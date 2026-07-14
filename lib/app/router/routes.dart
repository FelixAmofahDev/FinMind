class AppRoutes {
  const AppRoutes._();

  static const String authGate = '/';
  static const String home = authGate;
  static const String welcome = '/welcome';
  //Authenticatio//
  static const String signupBusiness = '/auth/signup/business';
  static const String signupLocation = '/auth/signup/location';
  static const String signupTracking = '/auth/signup/tracking';
  static const String signupCredentials = '/auth/signup/credentials';
  static const String verifyEmail = '/auth/verify-email';
  static const String login = '/auth/login';
  static const String onboardingComplete = '/onboarding/complete';
  //Products//
  static const String products = '/products';
  static const String productDetail = '/products/detail';
  static const String productCreate = '/products/create';
  static const String productEdit = '/products/edit';
  static const String restock = '/products/restock';
  //Dashboard//
  static const String dashboard = '/dashboard';
}