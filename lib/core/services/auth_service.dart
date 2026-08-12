import 'dart:async';

import '../errors/exceptions.dart';
import '../storage/secure_storage_service.dart';
import '../constants/api_constants.dart';
import 'package:dio/dio.dart';

class AuthService {
  AuthService(this._secureStorageService);

  final SecureStorageService _secureStorageService;
  final _authFailureController = StreamController<void>.broadcast();

  Stream<void> get onAuthFailure => _authFailureController.stream;

  void notifyAuthFailure() {
    _authFailureController.add(null);
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,
      headers: const <String, dynamic>{'Accept': 'application/json'},
    ),
  );

  Future<void> saveToken(String token) => _secureStorageService.saveToken(token);

  Future<String?> getToken() => _secureStorageService.getToken();

  Future<void> deleteToken() => _secureStorageService.deleteToken();

  Future<bool> refreshToken() async {
    final refreshToken = await _secureStorageService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiConstants.refreshToken,
        data: <String, dynamic>{'refreshToken': refreshToken},
      );

      final json = response.data ?? <String, dynamic>{};
      final dynamic rawData = json['data'];
      if (rawData is! Map<String, dynamic>) {
        return false;
      }

      final newAccessToken = rawData['accessToken'] as String? ?? '';
      final newRefreshToken = rawData['refreshToken'] as String? ?? '';
      if (newAccessToken.isEmpty || newRefreshToken.isEmpty) {
        return false;
      }

      await _secureStorageService.saveToken(newAccessToken);
      await _secureStorageService.saveRefreshToken(newRefreshToken);
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const ServerException('Invalid or expired refresh token', code: 401);
      }
      rethrow;
    }
  }

  Future<void> saveRefreshToken(String token) => _secureStorageService.saveRefreshToken(token);

  Future<String?> getRefreshToken() => _secureStorageService.getRefreshToken();

  Future<void> clearAuthData() async {
    await _secureStorageService.deleteToken();
    await _secureStorageService.deleteRefreshToken();
  }

  void dispose() {
    _authFailureController.close();
  }
}
