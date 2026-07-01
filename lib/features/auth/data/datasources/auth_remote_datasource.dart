import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/signup_draft.dart';
import '../models/auth_response_model.dart';
import '../models/signup_response_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<SignupResponseModel> signup(SignupDraft draft) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.authSignup,
        data: draft.toJson(),
      );

      if (response.data == null) {
        throw const ServerException('No data received from server');
      }

      return SignupResponseModel.fromJson(response.data!);
    } on DioException catch (error) {
      final failure = ErrorMapper.fromDioError(error);
      throw ServerException(failure.message, code: failure.code);
    }
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.authLogin,
        data: <String, dynamic>{
          'strategy': 'email_password',
          'email': email,
          'password': password,
        },
      );

      if (response.data == null) {
        throw const ServerException('No data received from server');
      }

      return AuthResponseModel.fromJson(response.data!);
    } on DioException catch (error) {
      final failure = ErrorMapper.fromDioError(error);
      throw ServerException(failure.message, code: failure.code);
    }
  }

  Future<AuthResponseModel> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.authVerifyEmail,
        data: <String, dynamic>{
          'email': email,
          'code': code,
        },
      );

      if (response.data == null) {
        throw const ServerException('No data received from server');
      }

      return AuthResponseModel.fromJson(response.data!);
    } on DioException catch (error) {
      final failure = ErrorMapper.fromDioError(error);
      throw ServerException(failure.message, code: failure.code);
    }
  }

  Future<void> resendVerification({required String email}) async {
    try {
      await _apiClient.post<dynamic>(
        ApiConstants.authResendVerification,
        data: <String, dynamic>{'email': email},
      );
    } on DioException catch (error) {
      final failure = ErrorMapper.fromDioError(error);
      throw ServerException(failure.message, code: failure.code);
    }
  }
}