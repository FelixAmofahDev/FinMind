import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/expense_input_model.dart';
import '../models/expense_model.dart';

class ExpensesRemoteDatasource {
  const ExpensesRemoteDatasource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<ExpenseModel>> listExpenses() async {
    try {
      final response = await _apiClient.get<dynamic>(ApiConstants.expenses);
      return _extractList(response.data)
          .whereType<Map<String, dynamic>>()
          .map(ExpenseModel.fromJson)
          .toList();
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  Future<ExpenseModel> createExpense({required ExpenseInputModel input}) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConstants.expenses,
        data: input.toJson(),
      );
      return ExpenseModel.fromJson(_extractMap(response.data));
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
      final dynamic expenses = responseData['expenses'];
      if (expenses is List<dynamic>) {
        return expenses;
      }
      final dynamic data = responseData['data'];
      if (data is List<dynamic>) {
        return data;
      }
      if (data is Map<String, dynamic> && data['expenses'] is List<dynamic>) {
        return data['expenses'] as List<dynamic>;
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
