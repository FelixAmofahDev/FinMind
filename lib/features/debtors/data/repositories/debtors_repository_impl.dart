import '../../domain/entities/debtor.dart';
import '../../domain/entities/debtor_payment.dart';
import '../../domain/entities/debtor_update.dart';
import '../../domain/entities/debtors_summary.dart';
import '../../domain/repositories/debtors_repository.dart';
import '../datasources/debtors_remote_datasource.dart';
import '../models/debtor_payment_request_model.dart';
import '../models/debtor_update_request_model.dart';

class DebtorsRepositoryImpl implements DebtorsRepository {
  const DebtorsRepositoryImpl({
    required DebtorsRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  final DebtorsRemoteDatasource _remoteDatasource;

  @override
  Future<DebtorsSummary> getDebtorsSummary() {
    return _remoteDatasource.getDebtorsSummary();
  }

  @override
  Future<List<Debtor>> listDebtors({
    String? search,
    bool? hasDebt,
    bool? isActive,
  }) {
    return _remoteDatasource
        .listDebtors(search: search, hasDebt: hasDebt, isActive: isActive)
        .then((models) => models.cast<Debtor>());
  }

  @override
  Future<void> recordPayment({
    required String debtorId,
    required DebtorPayment payment,
  }) {
    return _remoteDatasource.recordPayment(
      debtorId: debtorId,
      request: DebtorPaymentRequestModel.fromEntity(payment),
    );
  }

  @override
  Future<void> updateDebtor({
    required String debtorId,
    required DebtorUpdate update,
  }) {
    return _remoteDatasource.updateDebtor(
      debtorId: debtorId,
      request: DebtorUpdateRequestModel.fromEntity(update),
    );
  }

  @override
  Future<void> deactivateDebtor({required String debtorId}) {
    return _remoteDatasource.deactivateDebtor(debtorId: debtorId);
  }
}
