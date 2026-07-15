import '../entities/owner_transaction.dart';
import '../entities/owner_transaction_input.dart';
import '../repositories/owner_transactions_repository.dart';

class CreateOwnerWithdrawal {
  const CreateOwnerWithdrawal(this._repository);

  final OwnerTransactionsRepository _repository;

  Future<OwnerTransaction> call({required OwnerTransactionInput input}) {
    return _repository.createWithdrawal(input: input);
  }
}
