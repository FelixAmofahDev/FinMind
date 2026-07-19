import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../features/products/domain/entities/product.dart';
import '../../../../features/products/domain/entities/products_query.dart';
import '../../../../features/products/presentation/providers/products_provider.dart';
import '../../data/datasources/sale_remote_datasource.dart';
import '../../data/repositories/sale_repository_impl.dart';
import '../../domain/entities/sale.dart';
import '../../domain/entities/sale_request.dart';
import '../../domain/repositories/sale_repository.dart';
import '../../domain/usecases/create_sale.dart';

final saleRemoteDatasourceProvider = Provider<SaleRemoteDatasource>((ref) {
  return SaleRemoteDatasource(ref.read(apiClientProvider));
});

final saleRepositoryProvider = Provider<SaleRepository>((ref) {
  return SaleRepositoryImpl(remoteDatasource: ref.read(saleRemoteDatasourceProvider));
});

final createSaleUseCaseProvider = FutureProvider<CreateSale>((ref) async {
  return CreateSale(ref.watch(saleRepositoryProvider));
});

final salesControllerProvider =
    AsyncNotifierProvider<SalesController, Sale?>(SalesController.new);

class SalesController extends AsyncNotifier<Sale?> {
  @override
  Future<Sale?> build() async => null;

  Future<Sale> createSale({required SaleRequest request}) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final useCase = await ref.read(createSaleUseCaseProvider.future);
      return useCase(request: request);
    });
    state = result;
    if (result.value != null) {
      return result.value!;
    }
    throw result.error ?? Exception('Unknown error');
  }
}

class SalesSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setSearch(String value) => state = value.trim();
}

final salesSearchProvider =
    NotifierProvider<SalesSearchNotifier, String>(SalesSearchNotifier.new);

final salesProductsControllerProvider =
    AsyncNotifierProvider<SalesProductsController, List<Product>>(
  SalesProductsController.new,
);

class SalesProductsController extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    final search = ref.watch(salesSearchProvider);
    final listProductsUseCase = await ref.watch(listProductsUseCaseProvider.future);
    return listProductsUseCase(
      query: ProductsQuery(
        search: search.isEmpty ? null : search,
        isActive: true,
      ),
    );
  }

  Future<void> refresh() {
    ref.invalidateSelf();
    return future;
  }
}
