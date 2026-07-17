import '../../domain/entities/profit_loss_report.dart';
import '../../domain/repositories/reports_repository.dart';

class GetProfitLoss {
  const GetProfitLoss(this._repository);

  final ReportsRepository _repository;

  Future<ProfitLossReport> call({
    String? from,
    String? to,
  }) {
    return _repository.getProfitLoss(from: from, to: to);
  }
}
