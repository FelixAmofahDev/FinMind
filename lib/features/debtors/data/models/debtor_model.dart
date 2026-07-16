import '../../domain/entities/debtor.dart';

class DebtorModel extends Debtor {
  const DebtorModel({
    required super.id,
    required super.name,
    required super.phone,
    required super.amountOutstanding,
    required super.dueDate,
    required super.status,
    required super.isOverdue,
    required super.isDueSoon,
    required super.daysOverdue,
  });

  factory DebtorModel.fromJson(Map<String, dynamic> json) {
    return DebtorModel(
      id: json['debtorId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      amountOutstanding: _toDouble(json['amountOutstanding']),
      dueDate: _toDate(json['dueDate']),
      status: json['status'] as String? ?? '',
      isOverdue: json['isOverdue'] as bool? ?? false,
      isDueSoon: json['isDueSoon'] as bool? ?? false,
      daysOverdue: _toInt(json['daysOverdue']),
    );
  }

  static double _toDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value.trim()) ?? 0;
    }
    return 0;
  }

  static int _toInt(Object? value) {
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value.trim()) ?? 0;
    }
    return 0;
  }

  static DateTime? _toDate(Object? value) {
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value.trim());
    }
    return null;
  }
}
