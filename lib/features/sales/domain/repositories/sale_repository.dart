import '../entities/sale.dart';
import '../entities/sale_request.dart';

abstract class SaleRepository {
  Future<Sale> createSale({required SaleRequest request});
}
