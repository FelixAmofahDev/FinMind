import 'dart:io';
import 'dart:typed_data';

import '../entities/product.dart';
import '../entities/product_input.dart';
import '../entities/products_query.dart';
import '../entities/product_import_result.dart';

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
    String? sku,
    String? categoryId,
  });

  Future<Product> getProduct({required String productId});

  Future<Product> deactivateProduct({required String productId});

  Future<ProductImportResult> importProducts({required File csvFile});

  Future<Uint8List> downloadImportTemplate();
}
