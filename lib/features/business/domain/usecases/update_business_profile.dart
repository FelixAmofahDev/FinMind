import '../entities/business_profile.dart';
import '../repositories/business_repository.dart';
import '../entities/business_type.dart';

class UpdateBusinessProfile {
  const UpdateBusinessProfile(this._repository);

  final BusinessRepository _repository;

  Future<BusinessProfile> call({
    String? name,
    String? type,
    String? ownerName,
    String? phoneNumber,
    String? locationRegion,
    String? locationDistrict,
  }) {
    return _repository.updateBusinessProfile(
      name: name,
      type: type != null ? BusinessType.fromApi(type) : null,
      ownerName: ownerName,
      phoneNumber: phoneNumber,
      locationRegion: locationRegion,
      locationDistrict: locationDistrict,
    );
  }
}
