import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/signup_draft.dart';
import '../models/auth_response_model.dart';
import '../models/signup_response_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<SignupResponseModel> signup(SignupDraft draft) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiConstants.authSignup,
      data: draft.toJson(),
    );

    if (response.data == null) {
      throw Exception('No data received from server');
    }

    return SignupResponseModel.fromJson(response.data!);
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiConstants.authLogin,
      data: <String, dynamic>{
        'strategy': 'email_password',
        'email': email,
        'password': password,
      },
    );

    if (response.data == null) {
      throw Exception('No data received from server');
    }

    return AuthResponseModel.fromJson(response.data!);
  }

  Future<AuthResponseModel> verifyEmail({
    required String email,
    required String code,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiConstants.authVerifyEmail,
      data: <String, dynamic>{
        'email': email,
        'code': code,
      },
    );

    if (response.data == null) {
      throw Exception('No data received from server');
    }

    return AuthResponseModel.fromJson(response.data!);
  }

  Future<void> resendVerification({required String email}) async {
    await _apiClient.post<dynamic>(
      ApiConstants.authResendVerification,
      data: <String, dynamic>{'email': email},
    );
  }
}