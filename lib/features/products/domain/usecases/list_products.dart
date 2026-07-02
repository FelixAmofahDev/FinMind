import '../entities/product.dart';
import '../entities/products_query.dart';
import '../repositories/products_repository.dart';

class ListProducts {
  const ListProducts(this._repository);

  final ProductsRepository _repository;

  Future<List<Product>> call({ProductsQuery query = const ProductsQuery()}) {
    return _repository.listProducts(query: query);
  }
}