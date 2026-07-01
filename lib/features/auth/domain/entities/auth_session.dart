import 'business.dart';
import 'user.dart';

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

  AuthSession copyWith({
    String? accessToken,
    String? refreshToken,
    User? user,
    Business? business,
  }) {
    return AuthSession(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
      business: business ?? this.business,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is AuthSession &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        other.user == user &&
        other.business == business;
  }

  @override
  int get hashCode => Object.hash(accessToken, refreshToken, user, business);
}