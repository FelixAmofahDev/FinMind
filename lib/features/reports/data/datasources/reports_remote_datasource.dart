import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/cash_position_model.dart';
import '../models/profit_loss_model.dart';

class ReportsRemoteDatasource {
  const ReportsRemoteDatasource(this._apiClient);

  final ApiClient _apiClient;

  Future<ProfitLossModel> getProfitLoss({
    String? from,
    String? to,
  }) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.profitLoss,
        queryParameters: <String, dynamic>{
          if (from != null && from.isNotEmpty) 'from': from,
          if (to != null && to.isNotEmpty) 'to': to,
        },
      );
      return ProfitLossModel.fromJson(_extractMap(response.data));
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<CashPositionModel> getCashPosition() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConstants.cashPosition,
      );
      return CashPositionModel.fromJson(_extractMap(response.data));
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
