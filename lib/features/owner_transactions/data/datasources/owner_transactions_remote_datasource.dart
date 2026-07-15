import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/owner_transaction_type.dart';
import '../models/owner_transaction_input_model.dart';
import '../models/owner_transaction_model.dart';

class OwnerTransactionsRemoteDatasource {
  const OwnerTransactionsRemoteDatasource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<OwnerTransactionModel>> listDeposits() async {
    return _list(
      path: ApiConstants.ownerDeposits,
      key: 'deposits',
      type: OwnerTransactionType.deposit,
    );
  }

  Future<OwnerTransactionModel> createDeposit({
    required OwnerTransactionInputModel input,
  }) async {
    return _create(
      path: ApiConstants.ownerDeposits,
      input: input,
      type: OwnerTransactionType.deposit,
    );
  }

  Future<List<OwnerTransactionModel>> listWithdrawals() async {
    return _list(
      path: ApiConstants.ownerWithdrawals,
      key: 'withdrawals',
      type: OwnerTransactionType.withdrawal,
    );
  }

  Future<OwnerTransactionModel> createWithdrawal({
    required OwnerTransactionInputModel input,
  }) async {
    return _create(
      path: ApiConstants.ownerWithdrawals,
      input: input,
      type: OwnerTransactionType.withdrawal,
    );
  }

  Future<List<OwnerTransactionModel>> _list({
    required String path,
    required String key,
    required OwnerTransactionType type,
  }) async {
    try {
      final response = await _apiClient.get<dynamic>(path);
      return _extractList(response.data, key)
          .whereType<Map<String, dynamic>>()
          .map((json) => OwnerTransactionModel.fromJson(json, type: type))
          .toList();
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<OwnerTransactionModel> _create({
    required String path,
    required OwnerTransactionInputModel input,
    required OwnerTransactionType type,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        path,
        data: input.toJson(),
      );
      return OwnerTransactionModel.fromJson(_extractMap(response.data),
          type: type);
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  List<dynamic> _extractList(Object? responseData, String key) {
    if (responseData is List<dynamic>) {
      return responseData;
    }
    if (responseData is Map<String, dynamic>) {
      final dynamic direct = responseData[key];
      if (direct is List<dynamic>) {
        return direct;
      }
      final dynamic data = responseData['data'];
      if (data is List<dynamic>) {
        return data;
      }
      if (data is Map<String, dynamic> && data[key] is List<dynamic>) {
        return data[key] as List<dynamic>;
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
