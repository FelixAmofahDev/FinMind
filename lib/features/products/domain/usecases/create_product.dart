import '../entities/product.dart';
import '../entities/product_input.dart';
import '../repositories/products_repository.dart';

class CreateProduct {
  const CreateProduct(this._repository);

  final ProductsRepository _repository;

  Future<Product> call({required ProductInput input}) {
    return _repository.createProduct(input: input);
  }
}