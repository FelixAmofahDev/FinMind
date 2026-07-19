import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/debtor_model.dart';
import '../models/debtor_payment_request_model.dart';
import '../models/debtor_update_request_model.dart';
import '../models/debtors_summary_model.dart';

class DebtorsRemoteDatasource {
  const DebtorsRemoteDatasource(this._apiClient);

  final ApiClient _apiClient;

  Future<DebtorsSummaryModel> getDebtorsSummary() async {
    try {
      final response = await _apiClient.get<dynamic>(ApiConstants.debtorsSummary);
      return DebtorsSummaryModel.fromJson(_extractMap(response.data));
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<List<DebtorModel>> listDebtors({
    String? search,
    bool? hasDebt,
    bool? isActive,
  }) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiConstants.debtors,
        queryParameters: <String, dynamic>{
          if (search != null && search.isNotEmpty) 'search': search,
          if (hasDebt != null) 'hasDebt': hasDebt ? 'true' : 'false',
          if (isActive != null) 'isActive': isActive ? 'true' : 'false',
        },
      );
      return _extractList(response.data)
          .whereType<Map<String, dynamic>>()
          .map(DebtorModel.fromJson)
          .toList();
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<void> recordPayment({
    required String debtorId,
    required DebtorPaymentRequestModel request,
  }) async {
    try {
      await _apiClient.post<dynamic>(
        '${ApiConstants.debtors}/$debtorId/payments',
        data: request.toJson(),
      );
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<void> updateDebtor({
    required String debtorId,
    required DebtorUpdateRequestModel request,
  }) async {
    try {
      await _apiClient.put<dynamic>(
        '${ApiConstants.debtors}/$debtorId',
        data: request.toJson(),
      );
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<void> deactivateDebtor({required String debtorId}) async {
    try {
      await _apiClient.delete<dynamic>('${ApiConstants.debtors}/$debtorId');
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
