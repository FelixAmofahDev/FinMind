class SignupResponseModel {
  const SignupResponseModel({
    required this.success,
    required this.message,
    this.email,
  });

  final bool success;
  final String message;
  final String? email;

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    String? email;
    if (data is Map<String, dynamic>) {
      email = data['email'] as String?;
    }

    return SignupResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      email: email,
    );
  }
}