class ProductUpdateRequestModel {
  const ProductUpdateRequestModel({
    this.name,
    this.sellingPrice,
    this.costPrice,
    this.minimumStockQty,
    this.unitOfMeasure,
    this.sku,
    this.categoryId,
  });

  final String? name;
  final double? sellingPrice;
  final double? costPrice;
  final double? minimumStockQty;
  final String? unitOfMeasure;
  final String? sku;
  final String? categoryId;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (name != null) 'name': name,
      if (sellingPrice != null) 'sellingPrice': sellingPrice,
      if (costPrice != null) 'costPrice': costPrice,
      if (minimumStockQty != null) 'minimumStockQty': minimumStockQty,
      if (unitOfMeasure != null) 'unitOfMeasure': unitOfMeasure,
      if (sku != null) 'sku': sku,
      if (categoryId != null) 'categoryId': categoryId,
    };
  }
}
