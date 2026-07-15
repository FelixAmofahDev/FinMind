import '../entities/owner_transaction.dart';
import '../repositories/owner_transactions_repository.dart';

class ListOwnerDeposits {
  const ListOwnerDeposits(this._repository);

  final OwnerTransactionsRepository _repository;

  Future<List<OwnerTransaction>> call() {
    return _repository.listDeposits();
  }
}
