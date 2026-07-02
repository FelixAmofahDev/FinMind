import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/product_input_model.dart';
import '../models/product_model.dart';
import '../models/product_update_request_model.dart';

class ProductsRemoteDatasource {
  const ProductsRemoteDatasource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<ProductModel>> listProducts({Map<String, dynamic> queryParameters = const <String, dynamic>{}}) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiConstants.products,
        queryParameters: queryParameters.isEmpty ? null : queryParameters,
      );
      final rawList = _extractList(response.data);
      return rawList
          .whereType<Map<String, dynamic>>()
          .map(ProductModel.fromJson)
          .toList();
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<ProductModel> createProduct({required ProductInputModel input}) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.products,
        data: input.toJson(),
      );
      return ProductModel.fromJson(_extractMap(response.data));
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<ProductModel> updateProduct({required String productId, required ProductUpdateRequestModel request}) async {
    try {
      final response = await _apiClient.patch<Map<String, dynamic>>(
        '${ApiConstants.products}/$productId',
        data: request.toJson(),
      );
      return ProductModel.fromJson(_extractMap(response.data));
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<ProductModel> getProduct({required String productId}) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '${ApiConstants.products}/$productId',
      );
      return ProductModel.fromJson(_extractMap(response.data));
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<ProductModel> deactivateProduct({required String productId}) async {
    try {
      final response = await _apiClient.delete<Map<String, dynamic>>(
        '${ApiConstants.products}/$productId',
      );
      return ProductModel.fromJson(_extractMap(response.data));
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  List<dynamic> _extractList(Object? responseData) {
    if (responseData is List<dynamic>) {
      return responseData;
    }
    if (responseData is Map<String, dynamic>) {
      final dynamic data = responseData['data'];
      if (data is List<dynamic>) {
        return data;
      }
    }
    return const <dynamic>[];
  }

  Map<String, dynamic> _extractMap(Object? responseData) {
    if (responseData is Map<String, dynamic>) {
      final dynamic data = responseData['data'];
      if (data is Map<String, dynamic>) {
        return data;
      }
      return responseData;
    }
    return <String, dynamic>{};
  }
}
