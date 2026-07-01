import '../../domain/entities/business.dart';

class BusinessModel extends Business {
  const BusinessModel({
    required super.id,
    required super.name,
    required super.tier,
    required super.onboardingComplete,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      tier: json['tier'] as String? ?? '',
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
    );
  }

  factory BusinessModel.fromEntity(Business business) {
    return BusinessModel(
      id: business.id,
      name: business.name,
      tier: business.tier,
      onboardingComplete: business.onboardingComplete,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'tier': tier,
      'onboardingComplete': onboardingComplete,
    };
  }
}