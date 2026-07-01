class SignupPayload {
  const SignupPayload({
    required this.businessName,
    required this.businessType,
    required this.ownerName,
    required this.phoneNumber,
    required this.locationRegion,
    required this.locationDistrict,
    required this.tier,
    required this.recordingMode,
    required this.email,
    required this.password,
  });

  final String businessName;
  final String businessType;
  final String ownerName;
  final String phoneNumber;
  final String locationRegion;
  final String locationDistrict;
  final String tier;
  final String recordingMode;
  final String email;
  final String password;
}