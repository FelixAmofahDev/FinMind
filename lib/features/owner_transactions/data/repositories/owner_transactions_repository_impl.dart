import '../../domain/entities/owner_transaction.dart';
import '../../domain/entities/owner_transaction_input.dart';
import '../../domain/repositories/owner_transactions_repository.dart';
import '../datasources/owner_transactions_remote_datasource.dart';
import '../models/owner_transaction_input_model.dart';

class OwnerTransactionsRepositoryImpl implements OwnerTransactionsRepository {
  const OwnerTransactionsRepositoryImpl({
    required OwnerTransactionsRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  final OwnerTransactionsRemoteDatasource _remoteDatasource;

  @override
  Future<List<OwnerTransaction>> listDeposits() {
    return _remoteDatasource
        .listDeposits()
        .then((items) => items.cast<OwnerTransaction>());
  }

  @override
  Future<OwnerTransaction> createDeposit({
    required OwnerTransactionInput input,
  }) {
    return _remoteDatasource.createDeposit(
      input: OwnerTransactionInputModel.fromEntity(input),
    );
  }

  @override
  Future<List<OwnerTransaction>> listWithdrawals() {
    return _remoteDatasource
        .listWithdrawals()
        .then((items) => items.cast<OwnerTransaction>());
  }

  @override
  Future<OwnerTransaction> createWithdrawal({
    required OwnerTransactionInput input,
  }) {
    return _remoteDatasource.createWithdrawal(
      input: OwnerTransactionInputModel.fromEntity(input),
    );
  }
}
