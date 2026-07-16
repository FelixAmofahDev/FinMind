import 'package:finmind/features/debtors/presentation/widgets/amount_toggle.dart';
import 'package:finmind/features/debtors/presentation/widgets/debtor_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../shared/dialogs/confirm_dialog.dart';
import '../../../../shared/extensions/num_extensions.dart';
import '../../../../shared/models/payment_method.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/payment_method_selector.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/debtor.dart';
import '../../domain/entities/debtor_payment.dart';
import '../providers/debtors_provider.dart';

class RecordRepaymentPage extends ConsumerStatefulWidget {
  const RecordRepaymentPage({super.key});

  @override
  ConsumerState<RecordRepaymentPage> createState() =>
      _RecordRepaymentPageState();
}

class _RecordRepaymentPageState extends ConsumerState<RecordRepaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  Debtor? _debtor;
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
      if (args is Map<String, dynamic> && args['debtor'] is Debtor) {
        _debtor = args['debtor'] as Debtor;
        _amountController.text = _debtor!.amountOutstanding.toStringAsFixed(2);
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
          (_debtor?.amountOutstanding ?? 0).toStringAsFixed(2);
    });
  }

  void _selectPartPayment() {
    setState(() {
      _isFullAmount = false;
      _amountController.clear();
    });
  }

  Future<void> _submit() async {
    final debtor = _debtor;
    if (debtor == null) {
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(debtorsSummaryControllerProvider.notifier).recordPayment(
            debtorId: debtor.id,
            payment: DebtorPayment(
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

  Future<void> _archiveDebtor() async {
    final debtor = _debtor;
    if (debtor == null) {
      return;
    }
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Archive debtor?',
      message:
          '${debtor.name} will be removed from your debtors list. History is preserved.',
      confirmText: 'Archive',
      destructive: true,
    );
    if (!confirmed || !mounted) {
      return;
    }
    try {
      await ref
          .read(debtorsSummaryControllerProvider.notifier)
          .deactivateDebtor(debtorId: debtor.id);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debtor archived.')),
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
    final debtor = _debtor;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Record payment'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (debtor != null)
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  final navigator = Navigator.of(context);
                  final updated = await navigator.pushNamed(
                    AppRoutes.debtorEdit,
                    arguments: <String, dynamic>{'debtor': debtor},
                  );
                  if (updated == true && mounted) {
                    navigator.pop(true);
                  }
                } else if (value == 'archive') {
                  await _archiveDebtor();
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem<String>(value: 'edit', child: Text('Edit details')),
                PopupMenuItem<String>(
                    value: 'archive', child: Text('Archive debtor')),
              ],
            ),
        ],
      ),
      body: debtor == null
          ? const Center(child: Text('Debtor not found.'))
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    DebtorHeader(debtor: debtor),
                    const SizedBox(height: 18),
                    const Text(
                      'AMOUNT RECEIVED',
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
                        if (parsed > debtor.amountOutstanding + 0.001) {
                          return 'Amount exceeds the outstanding balance';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AmountToggle(
                            label: 'Full amount',
                            selected: _isFullAmount,
                            onTap: _selectFullAmount,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: AmountToggle(
                            label: 'Part payment',
                            selected: !_isFullAmount,
                            onTap: _selectPartPayment,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'RECEIVED AS',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.mute,
                      ),
                    ),
                    const SizedBox(height: 10),
                    PaymentMethodSelector(
                      selected: _paymentMethod,
                      onChanged: (method) =>
                          setState(() => _paymentMethod = method),
                    ),
                    const SizedBox(height: 18),
                    AppTextField(
                      controller: _notesController,
                      labelText: 'Notes (optional)',
                      hintText: 'e.g. Partial payment',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: _isSubmitting ? 'Recording...' : 'Record payment',
                      onPressed: _isSubmitting ? null : _submit,
                      isLoading: _isSubmitting,
                      backgroundColor: AppColors.teal,
                      expanded: true,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

