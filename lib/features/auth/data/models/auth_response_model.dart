import '../../domain/entities/user.dart';
import '../../domain/entities/business.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.emailVerified,
  });

  final String id;
  final String fullName;
  final String email;
  final String role;
  final bool emailVerified;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      emailVerified: json['emailVerified'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
      'emailVerified': emailVerified,
    };
  }

  User toEntity() {
    return User(
      id: id,
      fullName: fullName,
      email: email,
      role: role,
      emailVerified: emailVerified,
    );
  }
}

class BusinessModel {
  const BusinessModel({
    required this.id,
    required this.name,
    required this.tier,
    required this.onboardingComplete,
  });

  final String id;
  final String name;
  final String tier;
  final bool onboardingComplete;

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'] as String,
      name: json['name'] as String,
      tier: json['tier'] as String,
      onboardingComplete: json['onboardingComplete'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'tier': tier,
      'onboardingComplete': onboardingComplete,
    };
  }

  Business toEntity() {
    return Business(
      id: id,
      name: name,
      tier: tier,
      onboardingComplete: onboardingComplete,
    );
  }
}

class AuthResponseDataModel {
  const AuthResponseDataModel({
    required this.accessToken,
    required this.refreshToken,
    required this.business,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final BusinessModel business;
  final UserModel user;

  factory AuthResponseDataModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseDataModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      business: BusinessModel.fromJson(json['business'] as Map<String, dynamic>),
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'business': business.toJson(),
      'user': user.toJson(),
    };
  }
}

class AuthResponseModel {
  const AuthResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final AuthResponseDataModel data;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: AuthResponseDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}