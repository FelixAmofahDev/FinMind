import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/creditors_remote_datasource.dart';
import '../../data/repositories/creditors_repository_impl.dart';
import '../../domain/entities/creditor_payment.dart';
import '../../domain/entities/creditor_update.dart';
import '../../domain/entities/creditors_summary.dart';
import '../../domain/repositories/creditors_repository.dart';
import '../../domain/usecases/deactivate_creditor.dart';
import '../../domain/usecases/get_creditors_summary.dart';
import '../../domain/usecases/record_creditor_payment.dart';
import '../../domain/usecases/update_creditor.dart';

final creditorsRemoteDatasourceProvider =
    Provider<CreditorsRemoteDatasource>((ref) {
  return CreditorsRemoteDatasource(ref.read(apiClientProvider));
});

final creditorsRepositoryProvider = Provider<CreditorsRepository>((ref) {
  return CreditorsRepositoryImpl(
    remoteDatasource: ref.read(creditorsRemoteDatasourceProvider),
  );
});

final getCreditorsSummaryUseCaseProvider =
    Provider<GetCreditorsSummary>((ref) {
  return GetCreditorsSummary(ref.watch(creditorsRepositoryProvider));
});

final recordCreditorPaymentUseCaseProvider =
    Provider<RecordCreditorPayment>((ref) {
  return RecordCreditorPayment(ref.watch(creditorsRepositoryProvider));
});

final updateCreditorUseCaseProvider = Provider<UpdateCreditor>((ref) {
  return UpdateCreditor(ref.watch(creditorsRepositoryProvider));
});

final deactivateCreditorUseCaseProvider = Provider<DeactivateCreditor>((ref) {
  return DeactivateCreditor(ref.watch(creditorsRepositoryProvider));
});

final creditorsSummaryControllerProvider =
    AsyncNotifierProvider<CreditorsSummaryController, CreditorsSummary>(
  CreditorsSummaryController.new,
);

class CreditorsSummaryController extends AsyncNotifier<CreditorsSummary> {
  @override
  Future<CreditorsSummary> build() async {
    return ref.watch(getCreditorsSummaryUseCaseProvider)();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(getCreditorsSummaryUseCaseProvider)(),
    );
  }

  Future<void> recordPayment({
    required String creditorId,
    required CreditorPayment payment,
  }) async {
    await ref.read(recordCreditorPaymentUseCaseProvider)(
      creditorId: creditorId,
      payment: payment,
    );
    ref.invalidateSelf();
    await future;
  }

  Future<void> updateCreditor({
    required String creditorId,
    required CreditorUpdate update,
  }) async {
    await ref.read(updateCreditorUseCaseProvider)(
      creditorId: creditorId,
      update: update,
    );
    ref.invalidateSelf();
    await future;
  }

  Future<void> deactivateCreditor({required String creditorId}) async {
    await ref.read(deactivateCreditorUseCaseProvider)(creditorId: creditorId);
    ref.invalidateSelf();
    await future;
  }
}
