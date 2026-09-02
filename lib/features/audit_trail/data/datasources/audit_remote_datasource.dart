import 'package:dio/dio.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/audit_log.dart';
import '../../domain/entities/audit_query.dart';
import '../models/audit_log_model.dart';

class AuditRemoteDatasource {
  const AuditRemoteDatasource(this._apiClient);

  final ApiClient _apiClient;

  Future<List<AuditLogModel>> listAuditLogs({required AuditQuery query}) async {
    try {
      final response = await _apiClient.get<dynamic>(
        ApiConstants.audit,
        queryParameters: query.toJson(),
      );
      final raw = _extractAuditLogs(response.data);
      return raw
          .whereType<Map<String, dynamic>>()
          .map(AuditLogModel.fromJson)
          .toList();
    } on DioException catch (error) {
      throw ServerException(
        ErrorMapper.fromDioError(error).message,
        code: error.response?.statusCode,
      );
    }
  }

  List<dynamic> _extractAuditLogs(Object? responseData) {
    if (responseData is Map<String, dynamic>) {
      final dynamic data = responseData['data'];
      if (data is Map<String, dynamic>) {
        final dynamic logs = data['auditLogs'];
        if (logs is List<dynamic>) {
          return logs;
        }
      }
    }
    return const <dynamic>[];
  }
}
