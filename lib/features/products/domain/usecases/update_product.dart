import '../entities/product.dart';
import '../repositories/products_repository.dart';

class UpdateProduct {
  const UpdateProduct(this._repository);

  final ProductsRepository _repository;

  Future<Product> call({
    required String productId,
    String? name,
    double? sellingPrice,
    double? costPrice,
    double? minimumStockQty,
    String? unitOfMeasure,
    String? sku,
    String? categoryId,
  }) {
    return _repository.updateProduct(
      productId: productId,
      name: name,
      sellingPrice: sellingPrice,
      costPrice: costPrice,
      minimumStockQty: minimumStockQty,
      unitOfMeasure: unitOfMeasure,
      sku: sku,
      categoryId: categoryId,
    );
  }
}