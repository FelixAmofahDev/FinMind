import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/owner_transactions_remote_datasource.dart';
import '../../data/repositories/owner_transactions_repository_impl.dart';
import '../../domain/entities/owner_transaction.dart';
import '../../domain/entities/owner_transaction_input.dart';
import '../../domain/repositories/owner_transactions_repository.dart';
import '../../domain/usecases/create_owner_deposit.dart';
import '../../domain/usecases/create_owner_withdrawal.dart';
import '../../domain/usecases/list_owner_deposits.dart';
import '../../domain/usecases/list_owner_withdrawals.dart';

final ownerTransactionsRemoteDatasourceProvider =
    Provider<OwnerTransactionsRemoteDatasource>((ref) {
  return OwnerTransactionsRemoteDatasource(ref.read(apiClientProvider));
});

final ownerTransactionsRepositoryProvider =
    Provider<OwnerTransactionsRepository>((ref) {
  return OwnerTransactionsRepositoryImpl(
    remoteDatasource: ref.read(ownerTransactionsRemoteDatasourceProvider),
  );
});

final listOwnerDepositsUseCaseProvider = Provider<ListOwnerDeposits>((ref) {
  return ListOwnerDeposits(ref.watch(ownerTransactionsRepositoryProvider));
});

final createOwnerDepositUseCaseProvider = Provider<CreateOwnerDeposit>((ref) {
  return CreateOwnerDeposit(ref.watch(ownerTransactionsRepositoryProvider));
});

final listOwnerWithdrawalsUseCaseProvider =
    Provider<ListOwnerWithdrawals>((ref) {
  return ListOwnerWithdrawals(ref.watch(ownerTransactionsRepositoryProvider));
});

final createOwnerWithdrawalUseCaseProvider =
    Provider<CreateOwnerWithdrawal>((ref) {
  return CreateOwnerWithdrawal(ref.watch(ownerTransactionsRepositoryProvider));
});

final ownerDepositsControllerProvider =
    AsyncNotifierProvider<OwnerDepositsController, List<OwnerTransaction>>(
  OwnerDepositsController.new,
);

class OwnerDepositsController extends AsyncNotifier<List<OwnerTransaction>> {
  @override
  Future<List<OwnerTransaction>> build() async {
    return ref.watch(listOwnerDepositsUseCaseProvider)();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<OwnerTransaction?> addDeposit({
    required OwnerTransactionInput input,
  }) async {
    final created =
        await ref.read(createOwnerDepositUseCaseProvider)(input: input);
    ref.invalidateSelf();
    await future;
    return created;
  }
}

final ownerWithdrawalsControllerProvider =
    AsyncNotifierProvider<OwnerWithdrawalsController, List<OwnerTransaction>>(
  OwnerWithdrawalsController.new,
);

class OwnerWithdrawalsController extends AsyncNotifier<List<OwnerTransaction>> {
  @override
  Future<List<OwnerTransaction>> build() async {
    return ref.watch(listOwnerWithdrawalsUseCaseProvider)();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<OwnerTransaction?> addWithdrawal({
    required OwnerTransactionInput input,
  }) async {
    final created =
        await ref.read(createOwnerWithdrawalUseCaseProvider)(input: input);
    ref.invalidateSelf();
    await future;
    return created;
  }
}
