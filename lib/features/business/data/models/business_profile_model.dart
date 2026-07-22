import '../../domain/entities/business_profile.dart';
import '../../domain/entities/business_type.dart';

class BusinessProfileModel extends BusinessProfile {
  const BusinessProfileModel({
    required super.id,
    required super.name,
    required super.type,
    required super.ownerName,
    required super.phoneNumber,
    required super.locationRegion,
    required super.locationDistrict,
    required super.tier,
    required super.recordingMode,
    required super.onboardingComplete,
    required super.createdAt,
  });

  factory BusinessProfileModel.fromJson(Map<String, dynamic> json) {
    return BusinessProfileModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      type: BusinessType.fromApi(json['type'] as String?),
      ownerName: json['ownerName'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      locationRegion: json['locationRegion'] as String? ?? '',
      locationDistrict: json['locationDistrict'] as String? ?? '',
      tier: json['tier'] as String? ?? '',
      recordingMode: json['recordingMode'] as String? ?? '',
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type.apiValue,
      'ownerName': ownerName,
      'phoneNumber': phoneNumber,
      'locationRegion': locationRegion,
      'locationDistrict': locationDistrict,
      'tier': tier,
      'recordingMode': recordingMode,
      'onboardingComplete': onboardingComplete,
      'createdAt': createdAt,
    };
  }
}
