import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/auth_response_model.dart';
import '../models/auth_session_model.dart';
import '../models/onboarding_payload_model.dart';
import '../models/signup_payload_model.dart';
import '../models/signup_response_model.dart';

class AuthRemoteDatasource {
  const AuthRemoteDatasource(this._apiClient);

  final ApiClient _apiClient;

  Future<String> signup({required SignupPayloadModel payload}) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.signup,
        data: payload.toJson(),
      );
      final responseJson = response.data ?? <String, dynamic>{};
      final signupResponse = SignupResponseModel.fromJson(responseJson);
      return (signupResponse.email ?? payload.email).trim();
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<void> resendVerification({required String email}) async {
    try {
      await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.resendVerification,
        data: <String, dynamic>{'email': email},
      );
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<AuthSessionModel> verifyEmail({required String email, required String code}) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.verifyEmail,
        data: <String, dynamic>{
          'email': email,
          'code': code,
        },
      );
      return _parseAuthSession(response.data);
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<AuthSessionModel> login({required String email, required String password}) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.login,
        data: <String, dynamic>{
          'strategy': 'email_password',
          'email': email,
          'password': password,
        },
      );
      return _parseAuthSession(response.data);
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<bool> completeOnboarding({required OnboardingPayloadModel payload}) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.completeOnboarding,
        data: payload.toJson(),
      );
      final Map<String, dynamic> responseJson = response.data ?? <String, dynamic>{};
      final dynamic rawData = responseJson['data'];
      if (rawData is! Map<String, dynamic>) {
        return false;
      }
      return rawData['onboardingComplete'] as bool? ?? false;
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<void> logout({required String refreshToken}) async {
    try {
      await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.logout,
        data: <String, dynamic>{'refreshToken': refreshToken},
      );
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  AuthSessionModel _parseAuthSession(Map<String, dynamic>? responseData) {
    final responseJson = responseData ?? <String, dynamic>{};
    final authResponse = AuthResponseModel.fromJson(responseJson);
    return authResponse.data;
  }
}