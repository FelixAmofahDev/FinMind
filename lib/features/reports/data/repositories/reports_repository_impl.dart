import '../../domain/entities/cash_position_report.dart';
import '../../domain/entities/profit_loss_report.dart';
import '../../domain/repositories/reports_repository.dart';
import '../datasources/reports_remote_datasource.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  const ReportsRepositoryImpl({
    required ReportsRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  final ReportsRemoteDatasource _remoteDatasource;

  @override
  Future<ProfitLossReport> getProfitLoss({
    String? from,
    String? to,
  }) {
    return _remoteDatasource
        .getProfitLoss(from: from, to: to)
        .then((model) => model.toEntity());
  }

  @override
  Future<CashPositionReport> getCashPosition() {
    return _remoteDatasource
        .getCashPosition()
        .then((model) => model.toEntity());
  }
}
