import '../repositories/creditors_repository.dart';

class DeactivateCreditor {
  const DeactivateCreditor(this._repository);

  final CreditorsRepository _repository;

  Future<void> call({required String creditorId}) {
    return _repository.deactivateCreditor(creditorId: creditorId);
  }
}
