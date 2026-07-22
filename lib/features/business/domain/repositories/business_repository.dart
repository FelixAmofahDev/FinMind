import '../entities/business_profile.dart';
import '../entities/business_type.dart';

abstract class BusinessRepository {
  Future<BusinessProfile> getBusinessProfile();
  Future<BusinessProfile> updateBusinessProfile({
    String? name,
    BusinessType? type,
    String? ownerName,
    String? phoneNumber,
    String? locationRegion,
    String? locationDistrict,
  });
}
