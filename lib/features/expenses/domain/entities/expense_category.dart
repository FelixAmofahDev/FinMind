/// Expense categories accepted by the API:
/// transport | rent | wages | utilities | packaging | other.
enum ExpenseCategory {
  transport('transport', 'Transport'),
  rent('rent', 'Rent'),
  wages('wages', 'Wages'),
  utilities('utilities', 'Utilities'),
  packaging('packaging', 'Packaging'),
  other('other', 'Other');

  const ExpenseCategory(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static ExpenseCategory fromApi(String? value) {
    return ExpenseCategory.values.firstWhere(
      (category) => category.apiValue == value,
      orElse: () => ExpenseCategory.other,
    );
  }
}
