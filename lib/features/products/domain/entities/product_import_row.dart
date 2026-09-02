class ProductImportRow {
  ProductImportRow({
    this.id,
    this.name = '',
    this.sellingPrice = '',
    this.costPrice = '',
    this.openingQty = '',
    this.minimumStockQty = '',
    this.unitOfMeasure = 'piece',
    this.sku = '',
    this.error,
  });

  final String? id;
  final String name;
  final String sellingPrice;
  final String costPrice;
  final String openingQty;
  final String minimumStockQty;
  final String unitOfMeasure;
  final String sku;
  final String? error;

  ProductImportRow copyWith({
    String? id,
    String? name,
    String? sellingPrice,
    String? costPrice,
    String? openingQty,
    String? minimumStockQty,
    String? unitOfMeasure,
    String? sku,
    String? error,
  }) {
    return ProductImportRow(
      id: id ?? this.id,
      name: name ?? this.name,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      costPrice: costPrice ?? this.costPrice,
      openingQty: openingQty ?? this.openingQty,
      minimumStockQty: minimumStockQty ?? this.minimumStockQty,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      sku: sku ?? this.sku,
      error: error ?? this.error,
    );
  }

  bool get hasError => error != null && error!.isNotEmpty;

  Map<String, String> toCsvRow() {
    return <String, String>{
      'name': name,
      'sellingPrice': sellingPrice,
      'costPrice': costPrice,
      'openingQty': openingQty,
      'minimumStockQty': minimumStockQty,
      'unitOfMeasure': unitOfMeasure,
      'sku': sku,
    };
  }
}
