class Purchase {
  const Purchase({
    required this.id,
    required this.paymentMethod,
    required this.totalCost,
    required this.createdAt,
  });

  final String id;
  final String paymentMethod;
  final double totalCost;
  final DateTime? createdAt;
}
