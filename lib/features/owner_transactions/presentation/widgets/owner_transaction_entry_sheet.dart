import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/models/payment_method.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/payment_method_selector.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/owner_transaction_input.dart';
import '../../domain/entities/owner_transaction_type.dart';
import '../providers/owner_transactions_provider.dart';

/// Bottom sheet for recording an owner deposit or withdrawal. Returns `true`
/// when a transaction was successfully created.
class OwnerTransactionEntrySheet extends ConsumerStatefulWidget {
  const OwnerTransactionEntrySheet({super.key, required this.type});

  final OwnerTransactionType type;

  static Future<bool?> show(
    BuildContext context, {
    required OwnerTransactionType type,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => OwnerTransactionEntrySheet(type: type),
    );
  }

  @override
  ConsumerState<OwnerTransactionEntrySheet> createState() =>
      _OwnerTransactionEntrySheetState();
}

class _OwnerTransactionEntrySheetState
    extends ConsumerState<OwnerTransactionEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  PaymentMethod _paymentMethod = PaymentMethod.cash;
  bool _isSubmitting = false;

  bool get _isDeposit => widget.type == OwnerTransactionType.deposit;

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final input = OwnerTransactionInput(
      amount: double.tryParse(_amountController.text.trim()) ?? 0,
      paymentMethod: _paymentMethod,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    setState(() => _isSubmitting = true);
    try {
      if (_isDeposit) {
        await ref
            .read(ownerDepositsControllerProvider.notifier)
            .addDeposit(input: input);
      } else {
        await ref
            .read(ownerWithdrawalsControllerProvider.notifier)
            .addWithdrawal(input: input);
      }
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
    final accent = _isDeposit ? AppColors.teal : AppColors.purple;

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
                  _isDeposit ? 'Record a deposit' : 'Record a withdrawal',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isDeposit
                      ? 'Capital you are putting into the business.'
                      : 'Money you are taking out for personal use.',
                  style: const TextStyle(fontSize: 13, color: AppColors.mute),
                ),
                const SizedBox(height: 16),
                Text(
                  _isDeposit ? 'AMOUNT DEPOSITED' : 'AMOUNT WITHDRAWN',
                  style: const TextStyle(
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
                Text(
                  _isDeposit ? 'RECEIVED AS' : 'PAID WITH',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.mute,
                  ),
                ),
                const SizedBox(height: 10),
                PaymentMethodSelector(
                  selected: _paymentMethod,
                  accentColor: accent,
                  onChanged: (method) =>
                      setState(() => _paymentMethod = method),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: _notesController,
                  labelText: 'Notes (optional)',
                  hintText: _isDeposit
                      ? 'e.g. Equity investment to buy shop equipment'
                      : 'e.g. Personal drawing for home expenses',
                  maxLines: 2,
                ),
                const SizedBox(height: 22),
                PrimaryButton(
                  label: _isSubmitting
                      ? 'Saving...'
                      : (_isDeposit ? 'Save deposit' : 'Save withdrawal'),
                  onPressed: _isSubmitting ? null : _submit,
                  isLoading: _isSubmitting,
                  backgroundColor: accent,
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
