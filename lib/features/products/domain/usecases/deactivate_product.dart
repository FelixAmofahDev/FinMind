import '../entities/product.dart';
import '../repositories/products_repository.dart';

class DeactivateProduct {
  const DeactivateProduct(this._repository);

  final ProductsRepository _repository;

  Future<Product> call({required String productId}) {
    return _repository.deactivateProduct(productId: productId);
  }
}