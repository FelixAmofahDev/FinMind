enum BusinessType {
  provisionStore('provision_store', 'Provision store'),
  supermarket('supermarket', 'Supermarket'),
  pharmacy('pharmacy', 'Pharmacy'),
  hardware('hardware', 'Hardware store'),
  cosmetics('cosmetics', 'Cosmetics shop'),
  phoneAccessories('phone_accessories', 'Phone accessories'),
  other('other', 'Other');

  const BusinessType(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static BusinessType fromApi(String? value) {
    return BusinessType.values.firstWhere(
      (type) => type.apiValue == value,
      orElse: () => BusinessType.other,
    );
  }
}
