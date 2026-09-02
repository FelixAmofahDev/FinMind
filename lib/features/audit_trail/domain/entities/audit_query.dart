class AuditQuery {
  const AuditQuery({
    this.page = 1,
    this.limit = 20,
    this.entity,
    this.action,
    this.from,
    this.to,
  });

  final int page;
  final int limit;
  final String? entity;
  final String? action;
  final DateTime? from;
  final DateTime? to;

  AuditQuery copyWith({
    int? page,
    int? limit,
    String? entity,
    String? action,
    DateTime? from,
    DateTime? to,
  }) {
    return AuditQuery(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      entity: entity ?? this.entity,
      action: action ?? this.action,
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'page': page,
      'limit': limit,
      if (entity != null && entity!.trim().isNotEmpty) 'entity': entity!.trim(),
      if (action != null && action!.trim().isNotEmpty) 'action': action!.trim(),
      if (from != null) 'from': _formatDate(from!),
      if (to != null) 'to': _formatDate(to!),
    };
  }

  static String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
