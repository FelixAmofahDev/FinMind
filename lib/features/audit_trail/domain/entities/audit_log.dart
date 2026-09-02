class AuditLog {
  const AuditLog({
    required this.id,
    required this.actorId,
    required this.entity,
    required this.entityId,
    required this.action,
    required this.referenceNumber,
    required this.summary,
    required this.details,
    required this.createdAt,
  });

  final String id;
  final String actorId;
  final String entity;
  final String entityId;
  final String action;
  final String referenceNumber;
  final String summary;
  final Map<String, dynamic> details;
  final DateTime createdAt;
}
