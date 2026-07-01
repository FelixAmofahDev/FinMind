class SignupResponseDataModel {
  const SignupResponseDataModel({
    required this.message,
    required this.email,
  });

  final String message;
  final String email;

  factory SignupResponseDataModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseDataModel(
      message: json['message'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }
}

class SignupResponseModel {
  const SignupResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final SignupResponseDataModel data;

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: SignupResponseDataModel.fromJson(json['data'] as Map<String, dynamic>? ?? const <String, dynamic>{}),
    );
  }
}