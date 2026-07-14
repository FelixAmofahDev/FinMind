import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../data/datasources/purchase_remote_datasource.dart';
import '../../data/repositories/purchase_repository_impl.dart';
import '../../domain/entities/restock_request.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../../domain/usecases/create_purchase.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(secureStorageServiceProvider));
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(authService: ref.read(authServiceProvider));
});

final purchaseRemoteDatasourceProvider = Provider<PurchaseRemoteDatasource>((ref) {
  return PurchaseRemoteDatasource(ref.read(apiClientProvider));
});

final purchaseRepositoryProvider = Provider<PurchaseRepository>((ref) {
  return PurchaseRepositoryImpl(remoteDatasource: ref.read(purchaseRemoteDatasourceProvider));
});

final createPurchaseUseCaseProvider = FutureProvider<CreatePurchase>((ref) async {
  return CreatePurchase(ref.watch(purchaseRepositoryProvider));
});

final restockControllerProvider = AsyncNotifierProvider<RestockController, void>(RestockController.new);

class RestockController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> restock({required RestockRequest request}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = await ref.read(createPurchaseUseCaseProvider.future);
      await useCase(request: request);
    });
  }
}
