import '../entities/owner_transaction.dart';
import '../repositories/owner_transactions_repository.dart';

class ListOwnerWithdrawals {
  const ListOwnerWithdrawals(this._repository);

  final OwnerTransactionsRepository _repository;

  Future<List<OwnerTransaction>> call() {
    return _repository.listWithdrawals();
  }
}
