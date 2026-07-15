class Creditor {
  const Creditor({
    required this.id,
    required this.name,
    required this.phone,
    required this.amountOutstanding,
    required this.dueDate,
    required this.isOverdue,
    required this.isDueSoon,
    required this.daysOverdue,
  });

  final String id;
  final String name;
  final String phone;
  final double amountOutstanding;
  final DateTime? dueDate;
  final bool isOverdue;
  final bool isDueSoon;
  final int daysOverdue;

  bool get hasDueDate => dueDate != null;

  Creditor copyWith({
    String? id,
    String? name,
    String? phone,
    double? amountOutstanding,
    DateTime? dueDate,
    bool? isOverdue,
    bool? isDueSoon,
    int? daysOverdue,
  }) {
    return Creditor(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      amountOutstanding: amountOutstanding ?? this.amountOutstanding,
      dueDate: dueDate ?? this.dueDate,
      isOverdue: isOverdue ?? this.isOverdue,
      isDueSoon: isDueSoon ?? this.isDueSoon,
      daysOverdue: daysOverdue ?? this.daysOverdue,
    );
  }
}
