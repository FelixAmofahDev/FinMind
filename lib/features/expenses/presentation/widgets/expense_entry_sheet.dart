import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/models/payment_method.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/payment_method_selector.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/entities/expense_input.dart';
import '../providers/expenses_provider.dart';

/// Bottom sheet for logging a new expense. Returns `true` when an expense was
/// successfully created.
class ExpenseEntrySheet extends ConsumerStatefulWidget {
  const ExpenseEntrySheet({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ExpenseEntrySheet(),
    );
  }

  @override
  ConsumerState<ExpenseEntrySheet> createState() => _ExpenseEntrySheetState();
}

class _ExpenseEntrySheetState extends ConsumerState<ExpenseEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _paidToController = TextEditingController();
  final _notesController = TextEditingController();

  ExpenseCategory _category = ExpenseCategory.transport;
  PaymentMethod _paymentMethod = PaymentMethod.cash;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _amountController.dispose();
    _paidToController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ref.read(expensesControllerProvider.notifier).addExpense(
            input: ExpenseInput(
              amount: double.tryParse(_amountController.text.trim()) ?? 0,
              category: _category,
              paymentMethod: _paymentMethod,
              paidTo: _paidToController.text.trim().isEmpty
                  ? null
                  : _paidToController.text.trim(),
              notes: _notesController.text.trim().isEmpty
                  ? null
                  : _notesController.text.trim(),
            ),
          );
      if (!mounted) {
        return;
      }
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              children: [
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: AppColors.line,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                Text(
                  'Record an expense',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'AMOUNT SPENT',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.mute,
                  ),
                ),
                const SizedBox(height: 8),
                AppTextField(
                  controller: _amountController,
                  hintText: '0.00',
                  autofocus: true,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 14, right: 6),
                    child: Text(
                      'GHS',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.mute,
                      ),
                    ),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    final parsed = double.tryParse((value ?? '').trim());
                    if (parsed == null || parsed <= 0) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const Text(
                  'CATEGORY',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.mute,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 9,
                  runSpacing: 9,
                  children: ExpenseCategory.values.map((category) {
                    final isSelected = category == _category;
                    return GestureDetector(
                      onTap: () => setState(() => _category = category),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 11),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? AppColors.blue : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isSelected ? AppColors.blue : AppColors.line,
                          ),
                        ),
                        child: Text(
                          category.label,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color:
                                isSelected ? Colors.white : AppColors.inkSoft,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                const Text(
                  'PAID WITH',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.mute,
                  ),
                ),
                const SizedBox(height: 10),
                PaymentMethodSelector<PaymentMethod>(
                  selected: _paymentMethod,
                  methods: PaymentMethod.values,
                  methodLabel: (method) => method.label,
                  methodIcon: (method) => method.icon,
                  onChanged: (method) =>
                      setState(() => _paymentMethod = method),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _paidToController,
                  labelText: 'Paid to (optional)',
                  hintText: 'e.g. Trotro fare',
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _notesController,
                  labelText: 'Notes (optional)',
                  hintText: 'e.g. Commute to supplier',
                  maxLines: 2,
                ),
                const SizedBox(height: 22),
                PrimaryButton(
                  label: _isSubmitting ? 'Saving...' : 'Save expense',
                  onPressed: _isSubmitting ? null : _submit,
                  isLoading: _isSubmitting,
                  expanded: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
