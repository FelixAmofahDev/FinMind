class Product {
  const Product({
    required this.id,
    required this.name,
    required this.sellingPrice,
    required this.costPrice,
    required this.lastPurchasedCost,
    required this.openingQty,
    required this.currentStockQty,
    required this.minimumStockQty,
    required this.unitOfMeasure,
    required this.sku,
    required this.categoryId,
    required this.isActive,
    required this.isLowStock,
  });

  final String id;
  final String name;
  final double sellingPrice;
  final double costPrice;
  final double lastPurchasedCost;
  final double openingQty;
  final double currentStockQty;
  final double minimumStockQty;
  final String unitOfMeasure;
  final String sku;
  final String? categoryId;
  final bool isLowStock;
  final bool isActive;

  double get stockValue => currentStockQty * costPrice;

  double get openingStockValue => openingQty * costPrice;

  Product copyWith({
    String? id,
    String? name,
    double? sellingPrice,
    double? costPrice,
    double? lastPurchasedCost,
    double? openingQty,
    double? currentStockQty,
    double? minimumStockQty,
    String? unitOfMeasure,
    String? sku,
    String? categoryId,
    bool? isActive,
    bool? isLowStock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      costPrice: costPrice ?? this.costPrice,
      lastPurchasedCost: lastPurchasedCost ?? this.lastPurchasedCost,
      openingQty: openingQty ?? this.openingQty,
      currentStockQty: currentStockQty ?? this.currentStockQty,
      minimumStockQty: minimumStockQty ?? this.minimumStockQty,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      sku: sku ?? this.sku,
      categoryId: categoryId ?? this.categoryId,
      isActive: isActive ?? this.isActive,
      isLowStock: isLowStock ?? this.isLowStock,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.sellingPrice == sellingPrice &&
        other.costPrice == costPrice &&
        other.openingQty == openingQty &&
        other.currentStockQty == currentStockQty &&
        other.minimumStockQty == minimumStockQty &&
        other.unitOfMeasure == unitOfMeasure &&
        other.sku == sku &&
        other.categoryId == categoryId &&
        other.isActive == isActive &&
        other.isLowStock == isLowStock;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        sellingPrice,
        costPrice,
        openingQty,
        currentStockQty,
        minimumStockQty,
        unitOfMeasure,
        sku,
        categoryId,
        isActive,
        isLowStock,
      );
}
