import 'package:flutter/material.dart';

import '../config/app_constants.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import 'routes.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return _buildRoute(settings, const _StarterPage());
      case AppRoutes.dashboard:
        return _buildRoute(
          settings,
          const _SectionPage(
            title: 'Dashboard',
            subtitle: 'Track cash flow, inventory, and daily performance here.',
          ),
        );
      case AppRoutes.onboarding:
        return _buildRoute(
          settings,
          const _SectionPage(
            title: 'Onboarding',
            subtitle: 'Guide new users through setup and first steps.',
          ),
        );
      case AppRoutes.auth:
        return _buildRoute(
          settings,
          const _SectionPage(
            title: 'Authentication',
            subtitle: 'Add login, registration, and password recovery flows here.',
          ),
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

class _StarterPage extends StatelessWidget {
  const _StarterPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConfig.appName),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                'A clean starting point for Finmind',
                style: AppTextStyles.displayLarge,
              ),
              const SizedBox(height: 12),
              Text(
                AppConfig.appDescription,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              const _FeatureCard(
                title: 'Theme ready',
                subtitle: 'Color and typography tokens are centralized in app/theme.',
              ),
              const SizedBox(height: 12),
              const _FeatureCard(
                title: 'Routing ready',
                subtitle: 'Add feature pages and map them through AppRoutes.',
              ),
              const SizedBox(height: 12),
              const _FeatureCard(
                title: 'DI placeholder',
                subtitle: 'Expand InjectionContainer when services are introduced.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionPage extends StatelessWidget {
  const _SectionPage({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          subtitle,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
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

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.titleLarge),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}