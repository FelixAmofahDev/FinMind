import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/extensions/num_extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../domain/entities/expense.dart';
import '../providers/expenses_provider.dart';
import '../widgets/expense_entry_sheet.dart';
import '../widgets/expense_list_tile.dart';

class ExpensesPage extends ConsumerWidget {
  const ExpensesPage({super.key});

  Future<void> _openEntrySheet(BuildContext context, WidgetRef ref) async {
    final created = await ExpenseEntrySheet.show(context);
    if (created == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense saved.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesState = ref.watch(expensesControllerProvider);
    final controller = ref.read(expensesControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Expenses'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEntrySheet(context, ref),
        backgroundColor: AppColors.blue,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add expense'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refresh,
          child: expensesState.when(
            loading: () => const LoadingIndicator(message: 'Loading expenses...'),
            error: (error, _) => ListView(
              children: [
                const SizedBox(height: 80),
                EmptyStateWidget(
                  icon: Icons.error_outline,
                  title: 'Could not load expenses',
                  message: error.toString(),
                  action: TextButton(
                    onPressed: controller.refresh,
                    child: const Text('Retry'),
                  ),
                ),
              ],
            ),
            data: (expenses) => _buildContent(context, expenses),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<Expense> expenses) {
    if (expenses.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 100),
          EmptyStateWidget(
            icon: Icons.receipt_long_outlined,
            title: 'No expenses yet',
            message: 'Tap "Add expense" to log your first business expense.',
          ),
        ],
      );
    }

    final total = expenses.fold<double>(0, (sum, e) => sum + e.amount);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(19, 17, 19, 17),
          decoration: BoxDecoration(
            color: AppColors.coralDark,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total expenses',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFF3D3C7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                total.toCurrency(),
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${expenses.length} ${expenses.length == 1 ? 'entry' : 'entries'}',
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFFF3D3C7),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (int i = 0; i < expenses.length; i++)
                ExpenseListTile(
                  expense: expenses[i],
                  showDivider: i != expenses.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
