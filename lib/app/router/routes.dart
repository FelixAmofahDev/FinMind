class AppRoutes {
  const AppRoutes._();

  static const String authGate = '/';
  static const String home = '/dashboard';
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
  static const String sales = '/sales';
  //Dashboard//
  static const String dashboard = '/dashboard';
  //Home (shell) destinations
  static const String insights = '/insights';
  static const String businessSettings = '/business-settings';
  //Money & People//
  static const String moneyPeopleHub = '/money';
  static const String debtorsCreditorsHistory = '/money/history';
  static const String listDebtors = '/money/debtors';
  static const String listCreditors = '/money/creditors';
  static const String recordRepayment = '/money/debtors/repayment';
  static const String debtorEdit = '/money/debtors/edit';
  static const String recordSupplierPayment = '/money/creditors/payment';
  static const String creditorEdit = '/money/creditors/edit';
  static const String expenses = '/money/expenses';
  static const String ownerTransactions = '/money/owner-transactions';
}