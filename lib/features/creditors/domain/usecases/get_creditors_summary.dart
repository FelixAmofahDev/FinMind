import '../entities/creditors_summary.dart';
import '../repositories/creditors_repository.dart';

class GetCreditorsSummary {
  const GetCreditorsSummary(this._repository);

  final CreditorsRepository _repository;

  Future<CreditorsSummary> call() {
    return _repository.getCreditorsSummary();
  }
}
