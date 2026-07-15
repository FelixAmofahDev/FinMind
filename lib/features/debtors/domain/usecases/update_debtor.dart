import '../entities/debtor_update.dart';
import '../repositories/debtors_repository.dart';

class UpdateDebtor {
  const UpdateDebtor(this._repository);

  final DebtorsRepository _repository;

  Future<void> call({
    required String debtorId,
    required DebtorUpdate update,
  }) {
    return _repository.updateDebtor(debtorId: debtorId, update: update);
  }
}
