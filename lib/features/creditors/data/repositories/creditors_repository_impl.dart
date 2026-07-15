import '../../domain/entities/creditor_payment.dart';
import '../../domain/entities/creditor_update.dart';
import '../../domain/entities/creditors_summary.dart';
import '../../domain/repositories/creditors_repository.dart';
import '../datasources/creditors_remote_datasource.dart';
import '../models/creditor_payment_request_model.dart';
import '../models/creditor_update_request_model.dart';

class CreditorsRepositoryImpl implements CreditorsRepository {
  const CreditorsRepositoryImpl({
    required CreditorsRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  final CreditorsRemoteDatasource _remoteDatasource;

  @override
  Future<CreditorsSummary> getCreditorsSummary() {
    return _remoteDatasource.getCreditorsSummary();
  }

  @override
  Future<void> recordPayment({
    required String creditorId,
    required CreditorPayment payment,
  }) {
    return _remoteDatasource.recordPayment(
      creditorId: creditorId,
      request: CreditorPaymentRequestModel.fromEntity(payment),
    );
  }

  @override
  Future<void> updateCreditor({
    required String creditorId,
    required CreditorUpdate update,
  }) {
    return _remoteDatasource.updateCreditor(
      creditorId: creditorId,
      request: CreditorUpdateRequestModel.fromEntity(update),
    );
  }

  @override
  Future<void> deactivateCreditor({required String creditorId}) {
    return _remoteDatasource.deactivateCreditor(creditorId: creditorId);
  }
}
