import 'dart:io';

import '../../domain/entities/product_import_result.dart';
import '../../domain/repositories/products_repository.dart';

class ImportProducts {
  const ImportProducts(this._repository);

  final ProductsRepository _repository;

  Future<ProductImportResult> call({required File csvFile}) {
    return _repository.importProducts(csvFile: csvFile);
  }
}
