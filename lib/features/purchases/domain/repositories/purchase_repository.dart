import '../entities/purchase.dart';
import '../entities/restock_request.dart';

abstract class PurchaseRepository {
  Future<Purchase> createPurchase({required RestockRequest request});
}
