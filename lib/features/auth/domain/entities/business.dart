class Business {
  const Business({
    required this.id,
    required this.name,
    required this.tier,
    required this.onboardingComplete,
  });

  final String id;
  final String name;
  final String tier;
  final bool onboardingComplete;

  Business copyWith({
    String? id,
    String? name,
    String? tier,
    bool? onboardingComplete,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      tier: tier ?? this.tier,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Business &&
        other.id == id &&
        other.name == name &&
        other.tier == tier &&
        other.onboardingComplete == onboardingComplete;
  }

  @override
  int get hashCode => Object.hash(id, name, tier, onboardingComplete);
}