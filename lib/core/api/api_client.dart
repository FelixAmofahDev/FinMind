import 'package:dio/dio.dart';
import 'package:finmind/core/constants/api_constants.dart';
import 'package:finmind/core/constants/network_constants.dart';

import '../errors/error_mapper.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';
import '../services/auth_service.dart';

class ApiClient {
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
            final refreshResult = await _tryRefreshToken();
            if (refreshResult) {
              final request = error.requestOptions;
              final response = await this.dio.fetch(request);
              handler.resolve(response);
              return;
            }
          }
          handler.next(error);
        },
      ),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  final Dio dio;
  final AuthService? _authService;

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
    return statusCode == 401 && _authService != null;
  }

  Future<bool> _tryRefreshToken() async {
    final authService = _authService;
    if (authService == null) {
      return false;
    }
    return authService.refreshToken();
  }
}
