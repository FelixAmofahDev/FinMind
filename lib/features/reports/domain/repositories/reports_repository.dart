import '../entities/cash_position_report.dart';
import '../entities/profit_loss_report.dart';

abstract class ReportsRepository {
  Future<ProfitLossReport> getProfitLoss({
    String? from,
    String? to,
  });

  Future<CashPositionReport> getCashPosition();
}
