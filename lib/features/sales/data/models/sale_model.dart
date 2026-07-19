import '../../domain/entities/sale.dart';

class SaleModel extends Sale {
  const SaleModel({
    required super.referenceNumber,
    required super.totalRevenue,
    required super.totalCogs,
    required super.grossProfit,
    required super.itemCount,
    required super.isCredit,
    super.debtorId,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      referenceNumber: json['referenceNumber'] as String? ?? '',
      totalRevenue: _toDouble(json['totalRevenue']),
      totalCogs: _toDouble(json['totalCogs']),
      grossProfit: _toDouble(json['grossProfit']),
      itemCount: json['itemCount'] as int? ?? 0,
      isCredit: json['isCredit'] as bool? ?? false,
      debtorId: json['debtorId'] as String?,
    );
  }

  static double _toDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }
}
