import '../entities/debtors_summary.dart';
import '../repositories/debtors_repository.dart';

class GetDebtorsSummary {
  const GetDebtorsSummary(this._repository);

  final DebtorsRepository _repository;

  Future<DebtorsSummary> call() {
    return _repository.getDebtorsSummary();
  }
}
