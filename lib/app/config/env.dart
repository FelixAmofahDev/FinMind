enum AppEnvironment {
  development,
  staging,
  production,
}

class AppEnv {
  const AppEnv._();

  static const String _rawEnvironment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static AppEnvironment get current {
    switch (_rawEnvironment.toLowerCase()) {
      case 'production':
      case 'prod':
        return AppEnvironment.production;
      case 'staging':
      case 'stage':
        return AppEnvironment.staging;
      default:
        return AppEnvironment.development;
    }
  }

  static bool get isProduction => current == AppEnvironment.production;
  static bool get isStaging => current == AppEnvironment.staging;
  static bool get isDevelopment => current == AppEnvironment.development;
}