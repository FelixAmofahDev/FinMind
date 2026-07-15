import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/creditor_payment_request_model.dart';
import '../models/creditor_update_request_model.dart';
import '../models/creditors_summary_model.dart';

class CreditorsRemoteDatasource {
  const CreditorsRemoteDatasource(this._apiClient);

  final ApiClient _apiClient;

  Future<CreditorsSummaryModel> getCreditorsSummary() async {
    try {
      final response =
          await _apiClient.get<dynamic>(ApiConstants.creditorsSummary);
      return CreditorsSummaryModel.fromJson(_extractMap(response.data));
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<void> recordPayment({
    required String creditorId,
    required CreditorPaymentRequestModel request,
  }) async {
    try {
      await _apiClient.post<dynamic>(
        '${ApiConstants.creditors}/$creditorId/payments',
        data: request.toJson(),
      );
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<void> updateCreditor({
    required String creditorId,
    required CreditorUpdateRequestModel request,
  }) async {
    try {
      await _apiClient.put<dynamic>(
        '${ApiConstants.creditors}/$creditorId',
        data: request.toJson(),
      );
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<void> deactivateCreditor({required String creditorId}) async {
    try {
      await _apiClient.delete<dynamic>('${ApiConstants.creditors}/$creditorId');
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
