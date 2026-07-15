import '../entities/expense.dart';
import '../repositories/expenses_repository.dart';

class ListExpenses {
  const ListExpenses(this._repository);

  final ExpensesRepository _repository;

  Future<List<Expense>> call() {
    return _repository.listExpenses();
  }
}
