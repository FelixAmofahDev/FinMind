class ProductsQuery {
  const ProductsQuery({
    this.search,
    this.categoryId,
    this.isActive,
  });

  final String? search;
  final String? categoryId;
  final bool? isActive;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (search != null && search!.trim().isNotEmpty) 'search': search!.trim(),
      if (categoryId != null && categoryId!.trim().isNotEmpty) 'categoryId': categoryId!.trim(),
      if (isActive != null) 'isActive': isActive.toString(),
    };
  }
}
