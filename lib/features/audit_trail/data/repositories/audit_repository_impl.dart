import '../../domain/entities/audit_log.dart';
import '../../domain/entities/audit_query.dart';
import '../../domain/repositories/audit_repository.dart';
import '../datasources/audit_remote_datasource.dart';
import '../models/audit_log_model.dart';

class AuditRepositoryImpl implements AuditRepository {
  const AuditRepositoryImpl({
    required AuditRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  final AuditRemoteDatasource _remoteDatasource;

  @override
  Future<List<AuditLog>> listAuditLogs({required AuditQuery query}) async {
    final models = await _remoteDatasource.listAuditLogs(query: query);
    return models;
  }
}
