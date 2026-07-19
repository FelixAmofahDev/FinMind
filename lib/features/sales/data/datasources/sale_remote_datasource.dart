import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/sale_model.dart';
import '../models/sale_request_model.dart';

class SaleRemoteDatasource {
  const SaleRemoteDatasource(this._apiClient);

  final ApiClient _apiClient;

  Future<SaleModel> createSale({required SaleRequestModel request}) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.sales,
        data: request.toJson(),
      );
      return SaleModel.fromJson(_extractMap(response.data));
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
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
