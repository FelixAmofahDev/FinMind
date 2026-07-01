class SignupDraft {
  const SignupDraft({
    this.businessName = '',
    this.businessType = 'provision_store',
    this.ownerName = '',
    this.phoneNumber = '',
    this.locationRegion = '',
    this.locationDistrict = '',
    this.tier = 'tier2',
    this.recordingMode = 'transaction',
    this.email = '',
    this.password = '',
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

  SignupDraft copyWith({
    String? businessName,
    String? businessType,
    String? ownerName,
    String? phoneNumber,
    String? locationRegion,
    String? locationDistrict,
    String? tier,
    String? recordingMode,
    String? email,
    String? password,
  }) {
    return SignupDraft(
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      ownerName: ownerName ?? this.ownerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      locationRegion: locationRegion ?? this.locationRegion,
      locationDistrict: locationDistrict ?? this.locationDistrict,
      tier: tier ?? this.tier,
      recordingMode: recordingMode ?? this.recordingMode,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'businessName': businessName,
      'businessType': businessType,
      'ownerName': ownerName,
      'phoneNumber': phoneNumber,
      'locationRegion': locationRegion,
      'locationDistrict': locationDistrict,
      'tier': tier,
      'recordingMode': recordingMode,
      'email': email,
      'password': password,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignupDraft &&
          runtimeType == other.runtimeType &&
          businessName == other.businessName &&
          businessType == other.businessType &&
          ownerName == other.ownerName &&
          phoneNumber == other.phoneNumber &&
          locationRegion == other.locationRegion &&
          locationDistrict == other.locationDistrict &&
          tier == other.tier &&
          recordingMode == other.recordingMode &&
          email == other.email &&
          password == other.password;

  @override
  int get hashCode =>
      businessName.hashCode ^
      businessType.hashCode ^
      ownerName.hashCode ^
      phoneNumber.hashCode ^
      locationRegion.hashCode ^
      locationDistrict.hashCode ^
      tier.hashCode ^
      recordingMode.hashCode ^
      email.hashCode ^
      password.hashCode;
}