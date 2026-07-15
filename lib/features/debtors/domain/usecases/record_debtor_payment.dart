import '../entities/debtor_payment.dart';
import '../repositories/debtors_repository.dart';

class RecordDebtorPayment {
  const RecordDebtorPayment(this._repository);

  final DebtorsRepository _repository;

  Future<void> call({
    required String debtorId,
    required DebtorPayment payment,
  }) {
    return _repository.recordPayment(debtorId: debtorId, payment: payment);
  }
}
