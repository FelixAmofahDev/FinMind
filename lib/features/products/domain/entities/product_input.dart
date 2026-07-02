class ProductInput {
  const ProductInput({
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

  double get stockValue => openingQty * costPrice;
}
