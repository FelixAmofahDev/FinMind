import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../data/datasources/products_remote_datasource.dart';
import '../../data/repositories/products_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/product_input.dart';
import '../../domain/entities/products_query.dart';
import '../../domain/repositories/products_repository.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/deactivate_product.dart';
import '../../domain/usecases/get_product.dart';
import '../../domain/usecases/list_products.dart';
import '../../domain/usecases/update_product.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.read(secureStorageServiceProvider));
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(authService: ref.read(authServiceProvider));
});

final productsRemoteDatasourceProvider = Provider<ProductsRemoteDatasource>((ref) {
  return ProductsRemoteDatasource(ref.read(apiClientProvider));
});

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  return ProductsRepositoryImpl(remoteDatasource: ref.read(productsRemoteDatasourceProvider));
});

final productsSearchProvider = NotifierProvider<ProductsSearchNotifier, String>(ProductsSearchNotifier.new);

class ProductsSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void set(String value) {
    state = value.trim();
  }
}

final listProductsUseCaseProvider = FutureProvider<ListProducts>((ref) async {
  return ListProducts(ref.watch(productsRepositoryProvider));
});

final createProductUseCaseProvider = FutureProvider<CreateProduct>((ref) async {
  return CreateProduct(ref.watch(productsRepositoryProvider));
});

final updateProductUseCaseProvider = FutureProvider<UpdateProduct>((ref) async {
  return UpdateProduct(ref.watch(productsRepositoryProvider));
});

final getProductUseCaseProvider = FutureProvider<GetProduct>((ref) async {
  return GetProduct(ref.watch(productsRepositoryProvider));
});

final deactivateProductUseCaseProvider = FutureProvider<DeactivateProduct>((ref) async {
  return DeactivateProduct(ref.watch(productsRepositoryProvider));
});

final productsControllerProvider = AsyncNotifierProvider<ProductsController, List<Product>>(ProductsController.new);

class ProductsController extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() async {
    final search = ref.watch(productsSearchProvider);
    final listProductsUseCase = await ref.watch(listProductsUseCaseProvider.future);
    return listProductsUseCase(
      query: ProductsQuery(
        search: search,
        isActive: true,
      ),
    );
  }

  Future<Product?> addProduct({required ProductInput input}) async {
    final createProductUseCase = await ref.read(createProductUseCaseProvider.future);
    final created = await createProductUseCase(input: input);
    ref.invalidateSelf();
    return created;
  }

  Future<void> refreshProducts() async {
    ref.invalidateSelf();
  }

  void updateSearch(String? value) {
    ref.read(productsSearchProvider.notifier).state = value?.trim() ?? '';
  }

  Future<Product?> deactivateProduct({required String productId}) async {
    final deactivateProductUseCase = await ref.read(deactivateProductUseCaseProvider.future);
    final updated = await deactivateProductUseCase(productId: productId);
    ref.invalidateSelf();
    return updated;
  }

  Future<Product?> updateProduct({
    required String productId,
    String? name,
    double? sellingPrice,
    double? costPrice,
    double? minimumStockQty,
    String? unitOfMeasure,
    String? sku,
    String? categoryId,
  }) async {
    final updateProductUseCase = await ref.read(updateProductUseCaseProvider.future);
    final updated = await updateProductUseCase(
      productId: productId,
      name: name,
      sellingPrice: sellingPrice,
      costPrice: costPrice,
      minimumStockQty: minimumStockQty,
      unitOfMeasure: unitOfMeasure,
      sku: sku,
      categoryId: categoryId,
    );
    ref.invalidateSelf();
    return updated;
  }
}