import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/business_profile_model.dart';
import '../models/business_update_request.dart';

class BusinessRemoteDatasource {
  const BusinessRemoteDatasource(this._apiClient);

  final ApiClient _apiClient;

  Future<BusinessProfileModel> getBusinessProfile() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.business,
      );
      return BusinessProfileModel.fromJson(_extractData(response.data));
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<BusinessProfileModel> updateBusinessProfile({
    required BusinessUpdateRequest request,
  }) async {
    try {
      final response = await _apiClient.patch<Map<String, dynamic>>(
        ApiConstants.business,
        data: request.toJson(),
      );
      return BusinessProfileModel.fromJson(_extractData(response.data));
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Map<String, dynamic> _extractData(Object? responseData) {
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
