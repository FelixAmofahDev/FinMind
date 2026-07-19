import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/creditors_remote_datasource.dart';
import '../../data/repositories/creditors_repository_impl.dart';
import '../../domain/entities/creditor.dart';
import '../../domain/entities/creditor_payment.dart';
import '../../domain/entities/creditor_update.dart';
import '../../domain/entities/creditors_summary.dart';
import '../../domain/repositories/creditors_repository.dart';
import '../../domain/usecases/deactivate_creditor.dart';
import '../../domain/usecases/get_creditors_summary.dart';
import '../../domain/usecases/list_creditors.dart';
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

final listCreditorsUseCaseProvider = Provider<ListCreditors>((ref) {
  return ListCreditors(ref.watch(creditorsRepositoryProvider));
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

class ListCreditorsSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setSearch(String search) => state = search;
}

final listCreditorsSearchProvider =
    NotifierProvider<ListCreditorsSearchNotifier, String>(
  ListCreditorsSearchNotifier.new,
);

class ListCreditorsHasDebtNotifier extends Notifier<bool?> {
  @override
  bool? build() => true;

  void setHasDebt(bool? hasDebt) => state = hasDebt;
}

final listCreditorsHasDebtProvider =
    NotifierProvider<ListCreditorsHasDebtNotifier, bool?>(
  ListCreditorsHasDebtNotifier.new,
);

class ListCreditorsIsActiveNotifier extends Notifier<bool?> {
  @override
  bool? build() => true;

  void setIsActive(bool? isActive) => state = isActive;
}

final listCreditorsIsActiveProvider =
    NotifierProvider<ListCreditorsIsActiveNotifier, bool?>(
  ListCreditorsIsActiveNotifier.new,
);

final listCreditorsControllerProvider =
    AsyncNotifierProvider<ListCreditorsController, List<Creditor>>(
  ListCreditorsController.new,
);

class ListCreditorsController extends AsyncNotifier<List<Creditor>> {
  @override
  Future<List<Creditor>> build() async {
    final search = ref.read(listCreditorsSearchProvider);
    final hasDebt = ref.read(listCreditorsHasDebtProvider);
    final isActive = ref.read(listCreditorsIsActiveProvider);
    return ref.watch(listCreditorsUseCaseProvider)(
      search: search.isEmpty ? null : search,
      hasDebt: hasDebt,
      isActive: isActive,
    );
  }

  Future<void> refresh({
    String? search,
    bool? hasDebt,
    bool? isActive,
  }) async {
    if (search != null) ref.read(listCreditorsSearchProvider.notifier).setSearch(search);
    if (hasDebt != null) ref.read(listCreditorsHasDebtProvider.notifier).setHasDebt(hasDebt);
    if (isActive != null) ref.read(listCreditorsIsActiveProvider.notifier).setIsActive(isActive);
    ref.invalidateSelf();
    await future;
  }
}
