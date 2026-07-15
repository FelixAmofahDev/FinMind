import '../entities/creditor_payment.dart';
import '../repositories/creditors_repository.dart';

class RecordCreditorPayment {
  const RecordCreditorPayment(this._repository);

  final CreditorsRepository _repository;

  Future<void> call({
    required String creditorId,
    required CreditorPayment payment,
  }) {
    return _repository.recordPayment(creditorId: creditorId, payment: payment);
  }
}
