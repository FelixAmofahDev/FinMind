import '../entities/expense.dart';
import '../entities/expense_input.dart';

abstract class ExpensesRepository {
  Future<List<Expense>> listExpenses();

  Future<Expense> createExpense({required ExpenseInput input});
}
