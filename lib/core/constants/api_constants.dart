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
  static const String purchases = '/api/v1/purchases';
  static const String sales = '/api/v1/sales';

  // Money & People
  static const String debtorsSummary = '/api/v1/reports/debtors-summary';
  static const String creditorsSummary = '/api/v1/reports/creditors-summary';
  static const String profitLoss = '/api/v1/reports/profit-loss';
  static const String cashPosition = '/api/v1/reports/cash-position';
  static const String debtors = '/api/v1/debtors';
  static const String creditors = '/api/v1/creditors';
  static const String expenses = '/api/v1/expenses';
  static const String ownerDeposit = '/api/v1/owner/deposit';
  static const String ownerWithdrawal = '/api/v1/owner/withdrawal';
  static const String ownerGetDeposit = '/api/v1/owner/deposits';
  static const String ownerGetWithdrawal = '/api/v1/owner/withdrawals';
}