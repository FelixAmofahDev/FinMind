import '../../domain/entities/audit_log.dart';

class AuditLogModel extends AuditLog {
  const AuditLogModel({
    required super.id,
    required super.actorId,
    required super.entity,
    required super.entityId,
    required super.action,
    required super.referenceNumber,
    required super.summary,
    required super.details,
    required super.createdAt,
  });

  factory AuditLogModel.fromJson(Map<String, dynamic> json) {
    final createdAt = json['createdAt'];
    return AuditLogModel(
      id: json['id'] as String? ?? '',
      actorId: json['actorId'] as String? ?? '',
      entity: json['entity'] as String? ?? '',
      entityId: json['entityId'] as String? ?? '',
      action: json['action'] as String? ?? '',
      referenceNumber: json['referenceNumber'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      details: json['details'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['details'] as Map<String, dynamic>)
          : <String, dynamic>{},
      createdAt: createdAt is String ? DateTime.tryParse(createdAt) ?? DateTime.now() : DateTime.now(),
    );
  }
}
