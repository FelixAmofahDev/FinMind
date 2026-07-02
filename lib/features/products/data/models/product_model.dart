import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.sellingPrice,
    required super.costPrice,
    required super.openingQty,
    required super.minimumStockQty,
    required super.unitOfMeasure,
    required super.isActive,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      sellingPrice: _toDouble(json['sellingPrice']),
      costPrice: _toDouble(json['costPrice']),
      openingQty: _toDouble(json['openingQty'] ?? json['currentStockQty']),
      minimumStockQty: _toDouble(json['minimumStockQty']),
      unitOfMeasure: json['unitOfMeasure'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
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
}
