import '../entities/creditor_update.dart';
import '../repositories/creditors_repository.dart';

class UpdateCreditor {
  const UpdateCreditor(this._repository);

  final CreditorsRepository _repository;

  Future<void> call({
    required String creditorId,
    required CreditorUpdate update,
  }) {
    return _repository.updateCreditor(creditorId: creditorId, update: update);
  }
}
