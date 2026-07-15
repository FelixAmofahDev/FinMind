import '../entities/creditor_payment.dart';
import '../entities/creditor_update.dart';
import '../entities/creditors_summary.dart';

abstract class CreditorsRepository {
  Future<CreditorsSummary> getCreditorsSummary();

  Future<void> recordPayment({
    required String creditorId,
    required CreditorPayment payment,
  });

  Future<void> updateCreditor({
    required String creditorId,
    required CreditorUpdate update,
  });

  Future<void> deactivateCreditor({required String creditorId});
}
