import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.sellingPrice,
    required super.costPrice,
    required super.openingQty,
    required super.currentStockQty,
    required super.minimumStockQty,
    required super.unitOfMeasure,
    required super.sku,
    required super.categoryId,
    required super.isActive,
    required super.isLowStock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final openingQty = _toDouble(json['openingQty']);
    final currentStockQty = _toDouble(json['currentStockQty'] ?? json['openingQty']);
    final minQty = _toDouble(json['minimumStockQty']);

    return ProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      sellingPrice: _toDouble(json['sellingPrice']),
      costPrice: _toDouble(json['costPrice']),
      openingQty: openingQty,
      currentStockQty: currentStockQty,
      minimumStockQty: minQty,
      unitOfMeasure: json['unitOfMeasure'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      categoryId: json['categoryId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isLowStock: json['isLowStock'] as bool? ?? (currentStockQty <= minQty),
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