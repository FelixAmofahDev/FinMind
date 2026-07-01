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

  bool get isTier2 => tier == 'tier2';

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'tier': tier,
      'onboardingComplete': onboardingComplete,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Business &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          tier == other.tier &&
          onboardingComplete == other.onboardingComplete;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ tier.hashCode ^ onboardingComplete.hashCode;

  @override
  String toString() =>
      'Business(id: $id, name: $name, tier: $tier, onboardingComplete: $onboardingComplete)';
}