import '../entities/purchase.dart';
import '../entities/restock_request.dart';
import '../repositories/purchase_repository.dart';

class CreatePurchase {
  const CreatePurchase(this._repository);

  final PurchaseRepository _repository;

  Future<Purchase> call({required RestockRequest request}) {
    return _repository.createPurchase(request: request);
  }
}
