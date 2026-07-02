import '../entities/product.dart';
import '../repositories/products_repository.dart';

class GetProduct {
  const GetProduct(this._repository);

  final ProductsRepository _repository;

  Future<Product> call({required String productId}) {
    return _repository.getProduct(productId: productId);
  }
}