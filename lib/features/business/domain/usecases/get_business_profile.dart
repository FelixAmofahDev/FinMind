import '../entities/business_profile.dart';
import '../repositories/business_repository.dart';

class GetBusinessProfile {
  const GetBusinessProfile(this._repository);

  final BusinessRepository _repository;

  Future<BusinessProfile> call() {
    return _repository.getBusinessProfile();
  }
}
