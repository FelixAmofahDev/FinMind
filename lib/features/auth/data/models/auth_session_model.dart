import '../../domain/entities/auth_session.dart';
import 'business_model.dart';
import 'user_model.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.accessToken,
    required super.refreshToken,
    required super.user,
    required super.business,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? <String, dynamic>{}),
      business:
          BusinessModel.fromJson(json['business'] as Map<String, dynamic>? ?? <String, dynamic>{}),
    );
  }

  factory AuthSessionModel.fromEntity(AuthSession session) {
    return AuthSessionModel(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      user: UserModel.fromEntity(session.user),
      business: BusinessModel.fromEntity(session.business),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': UserModel.fromEntity(user).toJson(),
      'business': BusinessModel.fromEntity(business).toJson(),
    };
  }
}