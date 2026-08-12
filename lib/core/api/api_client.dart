import 'dart:async';

import 'package:dio/dio.dart';
import 'package:finmind/core/constants/api_constants.dart';
import 'package:finmind/core/constants/network_constants.dart';
import 'package:flutter/foundation.dart';

import '../errors/error_mapper.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';
import '../services/auth_service.dart';

class ApiClient {
  static const String _refreshRetryKey = 'refresh_retry_attempted';

  ApiClient({
    String? baseUrl,
    Dio? dio,
    AuthService? authService,
  })  : _authService = authService,
        dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl ?? ApiConstants.baseUrl,
                connectTimeout: NetworkConstants.connectTimeout,
                receiveTimeout: NetworkConstants.receiveTimeout,
                sendTimeout: NetworkConstants.sendTimeout,
                responseType: ResponseType.json,
                contentType: Headers.jsonContentType,
                headers: const <String, dynamic>{'Accept': 'application/json'},
              ),
            ) {
    this.dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (_isPublicEndpoint(options.path)) {
            return handler.next(options);
          }
          final token = await _authService?.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) async {
          if (_shouldAttemptTokenRefresh(error)) {
            try {
              final status = await _tryRefreshToken();
              if (status == _RefreshTokenStatus.success) {
                final request = error.requestOptions;
                request.extra[_refreshRetryKey] = true;

                final newToken = await _authService?.getToken();
                if (newToken != null && newToken.isNotEmpty) {
                  request.headers['Authorization'] = 'Bearer $newToken';
                }

                final response = await this.dio.fetch(request);
                handler.resolve(response);
                return;
              } else if (status == _RefreshTokenStatus.invalidToken) {
                await _authService?.clearAuthData();
                _authService?.notifyAuthFailure();
              } else {
                // transient refresh failure: pass original error through
              }
            } catch (_) {
              // pass original error through
            }
          }
          handler.next(error);
        },
      ),
      if (kDebugMode)
        LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  final Dio dio;
  final AuthService? _authService;
  Completer<_RefreshTokenStatus>? _refreshCompleter;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Failure mapError(Object error) {
    if (error is DioException) {
      return ErrorMapper.fromDioError(error);
    }
    if (error is AppException) {
      return ErrorMapper.fromException(error);
    }
    return const ServerFailure(message: 'Unexpected error');
  }

  bool _shouldAttemptTokenRefresh(DioException error) {
    final statusCode = error.response?.statusCode;
    final request = error.requestOptions;
    final alreadyRetried = request.extra[_refreshRetryKey] == true;
    final isRefreshRequest = request.path.contains(ApiConstants.refreshToken);
    final isPublicEndpoint = _isPublicEndpoint(request.path);

    return statusCode == 401 &&
        _authService != null &&
        !alreadyRetried &&
        !isRefreshRequest &&
        !isPublicEndpoint;
  }

  bool _isPublicEndpoint(String path) {
    return path.contains(ApiConstants.login) ||
        path.contains(ApiConstants.signup) ||
        path.contains(ApiConstants.verifyEmail) ||
        path.contains(ApiConstants.resendVerification) ||
        path.contains(ApiConstants.refreshToken);
  }

  Future<_RefreshTokenStatus> _tryRefreshToken() async {
    final authService = _authService;
    if (authService == null) {
      return _RefreshTokenStatus.transientFailure;
    }

    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    final completer = Completer<_RefreshTokenStatus>();
    _refreshCompleter = completer;

    try {
      final result = await authService.refreshToken();
      completer.complete(result ? _RefreshTokenStatus.success : _RefreshTokenStatus.invalidToken);
      return completer.future;
    } on ServerException catch (e) {
      final status = e.code == 401 ? _RefreshTokenStatus.invalidToken : _RefreshTokenStatus.transientFailure;
      completer.complete(status);
      return status;
    } catch (e) {
      completer.complete(_RefreshTokenStatus.transientFailure);
      return _RefreshTokenStatus.transientFailure;
    } finally {
      _refreshCompleter = null;
    }
  }
}

enum _RefreshTokenStatus { success, invalidToken, transientFailure }
