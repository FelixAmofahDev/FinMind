import '../../domain/entities/trial_balance_report.dart';
import '../../domain/repositories/reports_repository.dart';

class GetTrialBalance {
  const GetTrialBalance(this._repository);

  final ReportsRepository _repository;

  Future<TrialBalanceReport> call({String? asOf}) {
    return _repository.getTrialBalance(asOf: asOf);
  }
}
