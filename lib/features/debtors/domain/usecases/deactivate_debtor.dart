import '../repositories/debtors_repository.dart';

class DeactivateDebtor {
  const DeactivateDebtor(this._repository);

  final DebtorsRepository _repository;

  Future<void> call({required String debtorId}) {
    return _repository.deactivateDebtor(debtorId: debtorId);
  }
}
