import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/debtors_remote_datasource.dart';
import '../../data/repositories/debtors_repository_impl.dart';
import '../../domain/entities/debtor.dart';
import '../../domain/entities/debtor_payment.dart';
import '../../domain/entities/debtor_update.dart';
import '../../domain/entities/debtors_summary.dart';
import '../../domain/repositories/debtors_repository.dart';
import '../../domain/usecases/deactivate_debtor.dart';
import '../../domain/usecases/get_debtors_summary.dart';
import '../../domain/usecases/list_debtors.dart';
import '../../domain/usecases/record_debtor_payment.dart';
import '../../domain/usecases/update_debtor.dart';

final debtorsRemoteDatasourceProvider = Provider<DebtorsRemoteDatasource>((ref) {
  return DebtorsRemoteDatasource(ref.read(apiClientProvider));
});

final debtorsRepositoryProvider = Provider<DebtorsRepository>((ref) {
  return DebtorsRepositoryImpl(
    remoteDatasource: ref.read(debtorsRemoteDatasourceProvider),
  );
});

final getDebtorsSummaryUseCaseProvider = Provider<GetDebtorsSummary>((ref) {
  return GetDebtorsSummary(ref.watch(debtorsRepositoryProvider));
});

final listDebtorsUseCaseProvider = Provider<ListDebtors>((ref) {
  return ListDebtors(ref.watch(debtorsRepositoryProvider));
});

final recordDebtorPaymentUseCaseProvider = Provider<RecordDebtorPayment>((ref) {
  return RecordDebtorPayment(ref.watch(debtorsRepositoryProvider));
});

final updateDebtorUseCaseProvider = Provider<UpdateDebtor>((ref) {
  return UpdateDebtor(ref.watch(debtorsRepositoryProvider));
});

final deactivateDebtorUseCaseProvider = Provider<DeactivateDebtor>((ref) {
  return DeactivateDebtor(ref.watch(debtorsRepositoryProvider));
});

final debtorsSummaryControllerProvider =
    AsyncNotifierProvider<DebtorsSummaryController, DebtorsSummary>(
  DebtorsSummaryController.new,
);

class DebtorsSummaryController extends AsyncNotifier<DebtorsSummary> {
  @override
  Future<DebtorsSummary> build() async {
    return ref.watch(getDebtorsSummaryUseCaseProvider)();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(getDebtorsSummaryUseCaseProvider)(),
    );
  }

  Future<void> recordPayment({
    required String debtorId,
    required DebtorPayment payment,
  }) async {
    await ref.read(recordDebtorPaymentUseCaseProvider)(
      debtorId: debtorId,
      payment: payment,
    );
    ref.invalidateSelf();
    await future;
  }

  Future<void> updateDebtor({
    required String debtorId,
    required DebtorUpdate update,
  }) async {
    await ref.read(updateDebtorUseCaseProvider)(
      debtorId: debtorId,
      update: update,
    );
    ref.invalidateSelf();
    await future;
  }

  Future<void> deactivateDebtor({required String debtorId}) async {
    await ref.read(deactivateDebtorUseCaseProvider)(debtorId: debtorId);
    ref.invalidateSelf();
    await future;
  }
}

class ListDebtorsSearchNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setSearch(String search) => state = search;
}

final listDebtorsSearchProvider =
    NotifierProvider<ListDebtorsSearchNotifier, String>(
  ListDebtorsSearchNotifier.new,
);

class ListDebtorsHasDebtNotifier extends Notifier<bool?> {
  @override
  bool? build() => true;

  void setHasDebt(bool? hasDebt) => state = hasDebt;
}

final listDebtorsHasDebtProvider =
    NotifierProvider<ListDebtorsHasDebtNotifier, bool?>(
  ListDebtorsHasDebtNotifier.new,
);

class ListDebtorsIsActiveNotifier extends Notifier<bool?> {
  @override
  bool? build() => true;

  void setIsActive(bool? isActive) => state = isActive;
}

final listDebtorsIsActiveProvider =
    NotifierProvider<ListDebtorsIsActiveNotifier, bool?>(
  ListDebtorsIsActiveNotifier.new,
);

final listDebtorsControllerProvider =
    AsyncNotifierProvider<ListDebtorsController, List<Debtor>>(
  ListDebtorsController.new,
);

class ListDebtorsController extends AsyncNotifier<List<Debtor>> {
  @override
  Future<List<Debtor>> build() async {
    final search = ref.read(listDebtorsSearchProvider);
    final hasDebt = ref.read(listDebtorsHasDebtProvider);
    final isActive = ref.read(listDebtorsIsActiveProvider);
    return ref.watch(listDebtorsUseCaseProvider)(
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
    if (search != null) ref.read(listDebtorsSearchProvider.notifier).setSearch(search);
    if (hasDebt != null) ref.read(listDebtorsHasDebtProvider.notifier).setHasDebt(hasDebt);
    if (isActive != null) ref.read(listDebtorsIsActiveProvider.notifier).setIsActive(isActive);
    ref.invalidateSelf();
    await future;
  }
}

