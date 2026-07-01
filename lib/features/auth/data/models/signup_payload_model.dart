import '../../domain/entities/signup_payload.dart';

class SignupPayloadModel {
  const SignupPayloadModel({
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

  factory SignupPayloadModel.fromEntity(SignupPayload payload) {
    return SignupPayloadModel(
      businessName: payload.businessName,
      businessType: payload.businessType,
      ownerName: payload.ownerName,
      phoneNumber: payload.phoneNumber,
      locationRegion: payload.locationRegion,
      locationDistrict: payload.locationDistrict,
      tier: payload.tier,
      recordingMode: payload.recordingMode,
      email: payload.email,
      password: payload.password,
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
}