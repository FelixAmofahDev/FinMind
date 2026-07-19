import '../../domain/entities/debtor.dart';
import '../../domain/repositories/debtors_repository.dart';

class ListDebtors {
  const ListDebtors(this._repository);

  final DebtorsRepository _repository;

  Future<List<Debtor>> call({
    String? search,
    bool? hasDebt,
    bool? isActive,
  }) {
    return _repository.listDebtors(
      search: search,
      hasDebt: hasDebt,
      isActive: isActive,
    );
  }
}
