class SelectItem<T> {
  const SelectItem({
    required this.label,
    required this.value,
    this.enabled = true,
  });

  final String label;
  final T value;
  final bool enabled;

  SelectItem<T> copyWith({
    String? label,
    T? value,
    bool? enabled,
  }) {
    return SelectItem<T>(
      label: label ?? this.label,
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  String toString() => 'SelectItem(label: $label, value: $value, enabled: $enabled)';
}
