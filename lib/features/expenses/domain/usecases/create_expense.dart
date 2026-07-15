import '../entities/expense.dart';
import '../entities/expense_input.dart';
import '../repositories/expenses_repository.dart';

class CreateExpense {
  const CreateExpense(this._repository);

  final ExpensesRepository _repository;

  Future<Expense> call({required ExpenseInput input}) {
    return _repository.createExpense(input: input);
  }
}
