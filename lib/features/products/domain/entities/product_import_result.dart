class ProductImportError {
  const ProductImportError({
    required this.row,
    required this.name,
    required this.reason,
  });

  final int row;
  final String name;
  final String reason;
}

class ProductImportResult {
  const ProductImportResult({
    required this.created,
    required this.failed,
    required this.errors,
  });

  final int created;
  final int failed;
  final List<ProductImportError> errors;

  bool get hasErrors => errors.isNotEmpty;
}
