import '../entities/product.dart';
import '../entities/product_input.dart';
import '../entities/products_query.dart';

abstract class ProductsRepository {
  Future<List<Product>> listProducts({ProductsQuery query = const ProductsQuery()});

  Future<Product> createProduct({required ProductInput input});

  Future<Product> updateProduct({
    required String productId,
    String? name,
    double? sellingPrice,
    double? costPrice,
    double? minimumStockQty,
    String? unitOfMeasure,
    String? categoryId,
  });

  Future<Product> getProduct({required String productId});

  Future<Product> deactivateProduct({required String productId});
}
