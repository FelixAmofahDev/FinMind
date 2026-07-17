import '../../domain/entities/product.dart';
import '../../domain/entities/product_input.dart';
import '../../domain/entities/products_query.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_remote_datasource.dart';
import '../models/product_input_model.dart';
import '../models/product_update_request_model.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  const ProductsRepositoryImpl({
    required ProductsRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  final ProductsRemoteDatasource _remoteDatasource;

  @override
  Future<Product> createProduct({required ProductInput input}) async {
    return _remoteDatasource.createProduct(
      input: ProductInputModel.fromEntity(input),
    );
  }

  @override
  Future<Product> deactivateProduct({required String productId}) {
    return _remoteDatasource.deactivateProduct(productId: productId);
  }

  @override
  Future<Product> getProduct({required String productId}) {
    return _remoteDatasource.getProduct(productId: productId);
  }

  @override
  Future<List<Product>> listProducts({ProductsQuery query = const ProductsQuery()}) {
    return _remoteDatasource.listProducts(queryParameters: query.toJson()).then((products) => products.cast<Product>());
  }

  @override
  Future<Product> updateProduct({
    required String productId,
    String? name,
    double? sellingPrice,
    double? costPrice,
    double? minimumStockQty,
    String? unitOfMeasure,
    String? sku,
    String? categoryId,
  }) {
    return _remoteDatasource.updateProduct(
      productId: productId,
      request: ProductUpdateRequestModel(
        name: name,
        sellingPrice: sellingPrice,
        minimumStockQty: minimumStockQty,
        unitOfMeasure: unitOfMeasure,
        sku: sku,
        categoryId: categoryId,
      ),
    );
  }
}