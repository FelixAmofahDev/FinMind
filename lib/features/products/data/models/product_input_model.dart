import '../../domain/entities/product_input.dart';

class ProductInputModel {
  const ProductInputModel({
    required this.name,
    required this.sellingPrice,
    required this.costPrice,
    required this.openingQty,
    required this.minimumStockQty,
    required this.unitOfMeasure,
  });

  final String name;
  final double sellingPrice;
  final double costPrice;
  final double openingQty;
  final double minimumStockQty;
  final String unitOfMeasure;

  factory ProductInputModel.fromEntity(ProductInput input) {
    return ProductInputModel(
      name: input.name,
      sellingPrice: input.sellingPrice,
      costPrice: input.costPrice,
      openingQty: input.openingQty,
      minimumStockQty: input.minimumStockQty,
      unitOfMeasure: input.unitOfMeasure,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'sellingPrice': sellingPrice,
      'costPrice': costPrice,
      'openingQty': openingQty,
      'minimumStockQty': minimumStockQty,
      'unitOfMeasure': unitOfMeasure,
    };
  }
}
