import 'user.dart';
import 'business.dart';

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.business,
  });

  final String accessToken;
  final String refreshToken;
  final User user;
  final Business business;

  bool get canAccessDashboard => user.emailVerified && business.onboardingComplete;

  bool get needsOnboarding => !business.onboardingComplete;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthSession &&
          runtimeType == other.runtimeType &&
          accessToken == other.accessToken &&
          refreshToken == other.refreshToken &&
          user == other.user &&
          business == other.business;

  @override
  int get hashCode =>
      accessToken.hashCode ^
      refreshToken.hashCode ^
      user.hashCode ^
      business.hashCode;

  @override
  String toString() =>
      'AuthSession(user: $user, business: $business, canAccessDashboard: $canAccessDashboard)';
}