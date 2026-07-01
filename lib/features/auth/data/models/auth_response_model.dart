import 'auth_session_model.dart';

class AuthResponseModel {
  const AuthResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final AuthSessionModel data;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: AuthSessionModel.fromJson(json['data'] as Map<String, dynamic>? ?? <String, dynamic>{}),
    );
  }
}