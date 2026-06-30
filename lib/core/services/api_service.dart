import 'package:dio/dio.dart';

import '../api/api_client.dart';

class ApiService {
  ApiService(this._apiClient);

  final ApiClient _apiClient;

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters}) {
    return _apiClient.get<T>(path, queryParameters: queryParameters);
  }

  Future<Response<T>> post<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _apiClient.post<T>(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<T>> put<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _apiClient.put<T>(path, data: data, queryParameters: queryParameters);
  }

  Future<Response<T>> delete<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters}) {
    return _apiClient.delete<T>(path, data: data, queryParameters: queryParameters);
  }
}
