import '../entities/audit_log.dart';
import '../entities/audit_query.dart';
import '../repositories/audit_repository.dart';

class ListAuditLogs {
  const ListAuditLogs(this._repository);

  final AuditRepository _repository;

  Future<List<AuditLog>> call({required AuditQuery query}) {
    return _repository.listAuditLogs(query: query);
  }
}
