import 'business_type.dart';

class BusinessProfile {
  const BusinessProfile({
    required this.id,
    required this.name,
    required this.type,
    required this.ownerName,
    required this.phoneNumber,
    required this.locationRegion,
    required this.locationDistrict,
    required this.tier,
    required this.recordingMode,
    required this.onboardingComplete,
    required this.createdAt,
  });

  final String id;
  final String name;
  final BusinessType type;
  final String ownerName;
  final String phoneNumber;
  final String locationRegion;
  final String locationDistrict;
  final String tier;
  final String recordingMode;
  final bool onboardingComplete;
  final String createdAt;

  BusinessProfile copyWith({
    String? name,
    BusinessType? type,
    String? ownerName,
    String? phoneNumber,
    String? locationRegion,
    String? locationDistrict,
  }) {
    return BusinessProfile(
      id: id,
      name: name ?? this.name,
      type: type ?? this.type,
      ownerName: ownerName ?? this.ownerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      locationRegion: locationRegion ?? this.locationRegion,
      locationDistrict: locationDistrict ?? this.locationDistrict,
      tier: tier,
      recordingMode: recordingMode,
      onboardingComplete: onboardingComplete,
      createdAt: createdAt,
    );
  }
}
