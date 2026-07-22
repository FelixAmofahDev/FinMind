import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/business_remote_datasource.dart';
import '../../data/repositories/business_repository_impl.dart';
import '../../domain/entities/business_profile.dart';
import '../../domain/entities/business_type.dart';
import '../../domain/repositories/business_repository.dart';
import '../../domain/usecases/get_business_profile.dart';
import '../../domain/usecases/update_business_profile.dart';

final businessRemoteDatasourceProvider = Provider<BusinessRemoteDatasource>((ref) {
  return BusinessRemoteDatasource(ref.read(apiClientProvider));
});

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  return BusinessRepositoryImpl(
    remoteDatasource: ref.read(businessRemoteDatasourceProvider),
  );
});

final getBusinessProfileUseCaseProvider = Provider<GetBusinessProfile>((ref) {
  return GetBusinessProfile(ref.watch(businessRepositoryProvider));
});

final updateBusinessProfileUseCaseProvider = Provider<UpdateBusinessProfile>((ref) {
  return UpdateBusinessProfile(ref.watch(businessRepositoryProvider));
});

final businessProfileControllerProvider =
    AsyncNotifierProvider<BusinessProfileController, BusinessProfile>(
  BusinessProfileController.new,
);

class BusinessProfileController extends AsyncNotifier<BusinessProfile> {
  @override
  Future<BusinessProfile> build() async {
    final useCase = ref.read(getBusinessProfileUseCaseProvider);
    return useCase();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<BusinessProfile> updateProfile({
    String? name,
    BusinessType? type,
    String? ownerName,
    String? phoneNumber,
    String? locationRegion,
    String? locationDistrict,
  }) async {
    final useCase = ref.read(updateBusinessProfileUseCaseProvider);
    final updated = await useCase(
      name: name,
      type: type?.apiValue,
      ownerName: ownerName,
      phoneNumber: phoneNumber,
      locationRegion: locationRegion,
      locationDistrict: locationDistrict,
    );
    ref.invalidateSelf();
    await future;
    return updated;
  }
}
