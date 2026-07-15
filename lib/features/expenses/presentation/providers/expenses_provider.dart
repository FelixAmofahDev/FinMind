import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/expenses_remote_datasource.dart';
import '../../data/repositories/expenses_repository_impl.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_input.dart';
import '../../domain/repositories/expenses_repository.dart';
import '../../domain/usecases/create_expense.dart';
import '../../domain/usecases/list_expenses.dart';

final expensesRemoteDatasourceProvider =
    Provider<ExpensesRemoteDatasource>((ref) {
  return ExpensesRemoteDatasource(ref.read(apiClientProvider));
});

final expensesRepositoryProvider = Provider<ExpensesRepository>((ref) {
  return ExpensesRepositoryImpl(
    remoteDatasource: ref.read(expensesRemoteDatasourceProvider),
  );
});

final listExpensesUseCaseProvider = Provider<ListExpenses>((ref) {
  return ListExpenses(ref.watch(expensesRepositoryProvider));
});

final createExpenseUseCaseProvider = Provider<CreateExpense>((ref) {
  return CreateExpense(ref.watch(expensesRepositoryProvider));
});

final expensesControllerProvider =
    AsyncNotifierProvider<ExpensesController, List<Expense>>(
  ExpensesController.new,
);

class ExpensesController extends AsyncNotifier<List<Expense>> {
  @override
  Future<List<Expense>> build() async {
    return ref.watch(listExpensesUseCaseProvider)();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<Expense?> addExpense({required ExpenseInput input}) async {
    final created =
        await ref.read(createExpenseUseCaseProvider)(input: input);
    ref.invalidateSelf();
    await future;
    return created;
  }
}
