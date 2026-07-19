import '../../domain/entities/sale.dart';
import '../../domain/entities/sale_request.dart';
import '../../domain/repositories/sale_repository.dart';
import '../datasources/sale_remote_datasource.dart';
import '../models/sale_request_model.dart';

class SaleRepositoryImpl implements SaleRepository {
  const SaleRepositoryImpl({
    required SaleRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  final SaleRemoteDatasource _remoteDatasource;

  @override
  Future<Sale> createSale({required SaleRequest request}) {
    return _remoteDatasource.createSale(
      request: SaleRequestModel(request: request),
    );
  }
}
