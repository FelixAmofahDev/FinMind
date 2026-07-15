import '../entities/owner_transaction.dart';
import '../entities/owner_transaction_input.dart';

abstract class OwnerTransactionsRepository {
  Future<List<OwnerTransaction>> listDeposits();

  Future<OwnerTransaction> createDeposit({required OwnerTransactionInput input});

  Future<List<OwnerTransaction>> listWithdrawals();

  Future<OwnerTransaction> createWithdrawal({
    required OwnerTransactionInput input,
  });
}
