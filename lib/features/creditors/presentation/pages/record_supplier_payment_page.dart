import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../shared/dialogs/confirm_dialog.dart';
import '../../../../shared/extensions/num_extensions.dart';
import '../../../../shared/models/payment_method.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/payment_method_selector.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/creditor.dart';
import '../../domain/entities/creditor_payment.dart';
import '../providers/creditors_provider.dart';

class RecordSupplierPaymentPage extends ConsumerStatefulWidget {
  const RecordSupplierPaymentPage({super.key});

  @override
  ConsumerState<RecordSupplierPaymentPage> createState() =>
      _RecordSupplierPaymentPageState();
}

class _RecordSupplierPaymentPageState
    extends ConsumerState<RecordSupplierPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  Creditor? _creditor;
  bool _didInit = false;
  bool _isFullAmount = true;
  PaymentMethod _paymentMethod = PaymentMethod.cash;
  bool _isSubmitting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic> && args['creditor'] is Creditor) {
        _creditor = args['creditor'] as Creditor;
        _amountController.text = _creditor!.amountOutstanding.toStringAsFixed(2);
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _selectFullAmount() {
    setState(() {
      _isFullAmount = true;
      _amountController.text =
          (_creditor?.amountOutstanding ?? 0).toStringAsFixed(2);
    });
  }

  void _selectPartPayment() {
    setState(() {
      _isFullAmount = false;
      _amountController.clear();
    });
  }

  Future<void> _submit() async {
    final creditor = _creditor;
    if (creditor == null || !_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    setState(() => _isSubmitting = true);
    try {
      await ref
          .read(creditorsSummaryControllerProvider.notifier)
          .recordPayment(
            creditorId: creditor.id,
            payment: CreditorPayment(
              amountPaid: amount,
              paymentMethod: _paymentMethod,
              paymentDate: DateTime.now(),
              notes: _notesController.text.trim().isEmpty
                  ? null
                  : _notesController.text.trim(),
            ),
          );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment of ${amount.toCurrency()} recorded.')),
      );
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _archiveCreditor() async {
    final creditor = _creditor;
    if (creditor == null) {
      return;
    }
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Archive creditor?',
      message:
          '${creditor.name} will be removed from your creditors list. History is preserved.',
      confirmText: 'Archive',
      destructive: true,
    );
    if (!confirmed || !mounted) {
      return;
    }
    try {
      await ref
          .read(creditorsSummaryControllerProvider.notifier)
          .deactivateCreditor(creditorId: creditor.id);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Creditor archived.')),
      );
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final creditor = _creditor;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Record supplier payment'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (creditor != null)
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  final navigator = Navigator.of(context);
                  final updated = await navigator.pushNamed(
                    AppRoutes.creditorEdit,
                    arguments: <String, dynamic>{'creditor': creditor},
                  );
                  if (updated == true && mounted) {
                    navigator.pop(true);
                  }
                } else if (value == 'archive') {
                  await _archiveCreditor();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem<String>(
                    value: 'edit', child: Text('Edit details')),
                PopupMenuItem<String>(
                    value: 'archive', child: Text('Archive creditor')),
              ],
            ),
        ],
      ),
      body: creditor == null
          ? const Center(child: Text('Creditor not found.'))
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _CreditorHeader(creditor: creditor),
                    const SizedBox(height: 18),
                    const Text(
                      'AMOUNT PAID',
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
                      onChanged: (_) {
                        if (_isFullAmount) {
                          setState(() => _isFullAmount = false);
                        }
                      },
                      validator: (value) {
                        final parsed = double.tryParse((value ?? '').trim());
                        if (parsed == null || parsed <= 0) {
                          return 'Enter a valid amount';
                        }
                        if (parsed > creditor.amountOutstanding + 0.001) {
                          return 'Amount exceeds the outstanding balance';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _AmountToggle(
                            label: 'Full amount',
                            selected: _isFullAmount,
                            onTap: _selectFullAmount,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: _AmountToggle(
                            label: 'Part payment',
                            selected: !_isFullAmount,
                            onTap: _selectPartPayment,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 18),
                    AppTextField(
                      controller: _notesController,
                      labelText: 'Notes (optional)',
                      hintText: 'e.g. Paid off outstanding balance',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: _isSubmitting ? 'Recording...' : 'Record payment',
                      onPressed: _isSubmitting ? null : _submit,
                      isLoading: _isSubmitting,
                      expanded: true,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _CreditorHeader extends StatelessWidget {
  const _CreditorHeader({required this.creditor});

  final Creditor creditor;

  @override
  Widget build(BuildContext context) {
    final initial = creditor.name.trim().isNotEmpty
        ? creditor.name.trim()[0].toUpperCase()
        : '?';
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.coralLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              initial,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.coralDark,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  creditor.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'You owe ',
                      style: TextStyle(fontSize: 12.5, color: AppColors.mute),
                    ),
                    Text(
                      creditor.amountOutstanding.toCurrency(),
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coralDark,
                      ),
                    ),
                    if (creditor.isOverdue)
                      const Text(
                        ' · overdue',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.coralDark,
                        ),
                      ),
                  ],
                ),
                if (creditor.phone.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    creditor.phone,
                    style: TextStyle(fontSize: 12, color: AppColors.mute),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountToggle extends StatelessWidget {
  const _AmountToggle({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.blueLight : AppColors.surface,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: selected ? AppColors.blue : AppColors.line,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected ? AppColors.blueDark : AppColors.inkSoft,
          ),
        ),
      ),
    );
  }
}
