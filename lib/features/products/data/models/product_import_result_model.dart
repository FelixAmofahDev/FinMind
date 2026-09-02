import 'package:finmind/features/products/domain/entities/product_import_result.dart';

class ProductImportErrorModel {
  const ProductImportErrorModel({
    required this.row,
    required this.name,
    required this.reason,
  });

  factory ProductImportErrorModel.fromJson(Map<String, dynamic> json) {
    return ProductImportErrorModel(
      row: (json['row'] as num).toInt(),
      name: json['name'] as String? ?? '',
      reason: json['reason'] as String? ?? 'Unknown error',
    );
  }

  final int row;
  final String name;
  final String reason;

  ProductImportError toEntity() {
    return ProductImportError(
      row: row,
      name: name,
      reason: reason,
    );
  }
}

class ProductImportResultModel {
  const ProductImportResultModel({
    required this.created,
    required this.failed,
    required this.errors,
  });

  factory ProductImportResultModel.fromJson(Map<String, dynamic> json) {
    final rawErrors = json['errors'];
    final errors = <ProductImportErrorModel>[];
    if (rawErrors is List) {
      for (final item in rawErrors) {
        if (item is Map<String, dynamic>) {
          errors.add(ProductImportErrorModel.fromJson(item));
        }
      }
    }

    return ProductImportResultModel(
      created: (json['created'] as num).toInt(),
      failed: (json['failed'] as num).toInt(),
      errors: errors,
    );
  }

  final int created;
  final int failed;
  final List<ProductImportErrorModel> errors;

  ProductImportResult toEntity() {
    return ProductImportResult(
      created: created,
      failed: failed,
      errors: errors.map((e) => e.toEntity()).toList(),
    );
  }
}
