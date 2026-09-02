import 'dart:typed_data';

import '../../domain/repositories/products_repository.dart';

class DownloadImportTemplate {
  const DownloadImportTemplate(this._repository);

  final ProductsRepository _repository;

  Future<Uint8List> call() {
    return _repository.downloadImportTemplate();
  }
}
