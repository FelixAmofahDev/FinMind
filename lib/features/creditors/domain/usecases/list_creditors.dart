import '../../domain/entities/creditor.dart';
import '../../domain/repositories/creditors_repository.dart';

class ListCreditors {
  const ListCreditors(this._repository);

  final CreditorsRepository _repository;

  Future<List<Creditor>> call({
    String? search,
    bool? hasDebt,
    bool? isActive,
  }) {
    return _repository.listCreditors(
      search: search,
      hasDebt: hasDebt,
      isActive: isActive,
    );
  }
}
