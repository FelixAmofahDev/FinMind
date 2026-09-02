import '../entities/audit_log.dart';
import '../entities/audit_query.dart';

abstract class AuditRepository {
  Future<List<AuditLog>> listAuditLogs({required AuditQuery query});
}
