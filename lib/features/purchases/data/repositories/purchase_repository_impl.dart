import '../../domain/entities/purchase.dart';
import '../../domain/entities/restock_request.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../datasources/purchase_remote_datasource.dart';
import '../models/restock_request_model.dart';

class PurchaseRepositoryImpl implements PurchaseRepository {
  const PurchaseRepositoryImpl({
    required PurchaseRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  final PurchaseRemoteDatasource _remoteDatasource;

  @override
  Future<Purchase> createPurchase({required RestockRequest request}) {
    return _remoteDatasource.createPurchase(
      request: RestockRequestModel(request: request),
    );
  }
}
