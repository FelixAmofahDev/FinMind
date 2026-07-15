import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_input.dart';
import '../../domain/repositories/expenses_repository.dart';
import '../datasources/expenses_remote_datasource.dart';
import '../models/expense_input_model.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  const ExpensesRepositoryImpl({
    required ExpensesRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  final ExpensesRemoteDatasource _remoteDatasource;

  @override
  Future<List<Expense>> listExpenses() {
    return _remoteDatasource
        .listExpenses()
        .then((expenses) => expenses.cast<Expense>());
  }

  @override
  Future<Expense> createExpense({required ExpenseInput input}) {
    return _remoteDatasource.createExpense(
      input: ExpenseInputModel.fromEntity(input),
    );
  }
}
