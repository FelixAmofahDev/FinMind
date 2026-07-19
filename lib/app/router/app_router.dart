import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/auth_gate_page.dart';
import '../../features/auth/presentation/pages/email_verification_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_business_page.dart';
import '../../features/auth/presentation/pages/signup_credentials_page.dart';
import '../../features/auth/presentation/pages/signup_location_page.dart';
import '../../features/auth/presentation/pages/signup_tracking_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/products/presentation/pages/products_page.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/products/presentation/pages/product_form_page.dart';
import '../../features/products/presentation/pages/product_edit_page.dart';
import '../../features/purchases/presentation/pages/restock_page.dart';
import '../../features/sales/presentation/pages/sales_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_completion_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import '../../features/money_people_hub/presentation/pages/money_people_hub_page.dart';
import '../../features/debtors/presentation/pages/record_repayment_page.dart';
import '../../features/debtors/presentation/pages/debtor_edit_page.dart';
import '../../features/creditors/presentation/pages/record_supplier_payment_page.dart';
import '../../features/creditors/presentation/pages/creditor_edit_page.dart';
import '../../features/expenses/presentation/pages/expenses_page.dart';
import '../../features/owner_transactions/domain/entities/owner_transaction_type.dart';
import '../../features/owner_transactions/presentation/pages/owner_transactions_page.dart';
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
      case AppRoutes.products:
        return _buildRoute(settings, const ProductsPage());
      case AppRoutes.productDetail:
        return _buildRoute(settings, const ProductDetailPage());
      case AppRoutes.productCreate:
        return _buildRoute(settings, const ProductFormPage());
      case AppRoutes.productEdit:
        return _buildRoute(settings, const ProductEditPage());
      case AppRoutes.restock:
        return _buildRoute(settings, const RestockPage());
      case AppRoutes.sales:
        return _buildRoute(settings, const SalesPage());
      case AppRoutes.onboardingComplete:
        return _buildRoute(settings, const OnboardingCompletionPage());
      case AppRoutes.dashboard:
        return _buildRoute(settings, const DashboardPage());
      case AppRoutes.home:
        return _buildRoute(settings, const DashboardPage(initialIndex: 0));
      case AppRoutes.insights:
        return _buildRoute(settings, const DashboardPage(initialIndex: 1));
      case AppRoutes.moneyPeopleHub:
        return _buildRoute(settings, const DashboardPage(initialIndex: 2));
      case AppRoutes.businessSettings:
        return _buildRoute(settings, const DashboardPage(initialIndex: 3));
      case AppRoutes.moneyPeopleHub:
        return _buildRoute(settings, const MoneyPeopleHubPage());
      case AppRoutes.recordRepayment:
        return _buildRoute(settings, const RecordRepaymentPage());
      case AppRoutes.debtorEdit:
        return _buildRoute(settings, const DebtorEditPage());
      case AppRoutes.recordSupplierPayment:
        return _buildRoute(settings, const RecordSupplierPaymentPage());
      case AppRoutes.creditorEdit:
        return _buildRoute(settings, const CreditorEditPage());
      case AppRoutes.expenses:
        return _buildRoute(settings, const ExpensesPage());
      case AppRoutes.ownerTransactions:
        final args = settings.arguments;
        final initialTab = args is Map<String, dynamic> &&
                args['tab'] is OwnerTransactionType
            ? args['tab'] as OwnerTransactionType
            : null;
        return _buildRoute(
          settings,
          OwnerTransactionsPage(initialTab: initialTab),
        );
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