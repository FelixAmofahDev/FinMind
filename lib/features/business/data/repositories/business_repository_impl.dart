import '../../domain/entities/business_profile.dart';
import '../../domain/entities/business_type.dart';
import '../../domain/repositories/business_repository.dart';
import '../datasources/business_remote_datasource.dart';
import '../models/business_update_request.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  const BusinessRepositoryImpl({
    required BusinessRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  final BusinessRemoteDatasource _remoteDatasource;

  @override
  Future<BusinessProfile> getBusinessProfile() {
    return _remoteDatasource.getBusinessProfile();
  }

  @override
  Future<BusinessProfile> updateBusinessProfile({
    String? name,
    BusinessType? type,
    String? ownerName,
    String? phoneNumber,
    String? locationRegion,
    String? locationDistrict,
  }) {
    return _remoteDatasource.updateBusinessProfile(
      request: BusinessUpdateRequest(
        name: name,
        type: type?.apiValue,
        ownerName: ownerName,
        phoneNumber: phoneNumber,
        locationRegion: locationRegion,
        locationDistrict: locationDistrict,
      ),
    );
  }
}
