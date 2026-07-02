class Product {
  const Product({
    required this.id,
    required this.name,
    required this.sellingPrice,
    required this.costPrice,
    required this.openingQty,
    required this.minimumStockQty,
    required this.unitOfMeasure,
    required this.isActive,
  });

  final String id;
  final String name;
  final double sellingPrice;
  final double costPrice;
  final double openingQty;
  final double minimumStockQty;
  final String unitOfMeasure;
  final bool isActive;

  double get stockValue => openingQty * costPrice;

  Product copyWith({
    String? id,
    String? name,
    double? sellingPrice,
    double? costPrice,
    double? openingQty,
    double? minimumStockQty,
    String? unitOfMeasure,
    bool? isActive,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      costPrice: costPrice ?? this.costPrice,
      openingQty: openingQty ?? this.openingQty,
      minimumStockQty: minimumStockQty ?? this.minimumStockQty,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      isActive: isActive ?? this.isActive,
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
        other.minimumStockQty == minimumStockQty &&
        other.unitOfMeasure == unitOfMeasure &&
        other.isActive == isActive;
  }

  @override
  int get hashCode => Object.hash(id, name, sellingPrice, costPrice, openingQty, minimumStockQty, unitOfMeasure, isActive);
}
