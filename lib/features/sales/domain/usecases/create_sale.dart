import '../entities/sale.dart';
import '../entities/sale_request.dart';
import '../repositories/sale_repository.dart';

class CreateSale {
  const CreateSale(this._repository);

  final SaleRepository _repository;

  Future<Sale> call({required SaleRequest request}) {
    return _repository.createSale(request: request);
  }
}
