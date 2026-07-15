import '../entities/debtor_payment.dart';
import '../entities/debtor_update.dart';
import '../entities/debtors_summary.dart';

abstract class DebtorsRepository {
  Future<DebtorsSummary> getDebtorsSummary();

  Future<void> recordPayment({
    required String debtorId,
    required DebtorPayment payment,
  });

  Future<void> updateDebtor({
    required String debtorId,
    required DebtorUpdate update,
  });

  Future<void> deactivateDebtor({required String debtorId});
}
