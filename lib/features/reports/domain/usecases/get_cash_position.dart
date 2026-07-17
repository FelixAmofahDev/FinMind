import '../../domain/entities/cash_position_report.dart';
import '../../domain/repositories/reports_repository.dart';

class GetCashPosition {
  const GetCashPosition(this._repository);

  final ReportsRepository _repository;

  Future<CashPositionReport> call() {
    return _repository.getCashPosition();
  }
}
