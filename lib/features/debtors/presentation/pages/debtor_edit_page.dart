import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/debtor.dart';
import '../../domain/entities/debtor_update.dart';
import '../providers/debtors_provider.dart';

class DebtorEditPage extends ConsumerStatefulWidget {
  const DebtorEditPage({super.key});

  @override
  ConsumerState<DebtorEditPage> createState() => _DebtorEditPageState();
}

class _DebtorEditPageState extends ConsumerState<DebtorEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _amountController = TextEditingController();
  final _dueDateController = TextEditingController();

  Debtor? _debtor;
  DateTime? _dueDate;
  bool _didInit = false;
  bool _isSubmitting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic> && args['debtor'] is Debtor) {
        final debtor = args['debtor'] as Debtor;
        _debtor = debtor;
        _nameController.text = debtor.name;
        _phoneController.text = debtor.phone;
        _amountController.text = debtor.amountOutstanding.toStringAsFixed(2);
        _dueDate = debtor.dueDate;
        if (debtor.dueDate != null) {
          _dueDateController.text =
              DateFormat('yyyy-MM-dd').format(debtor.dueDate!);
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _amountController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dueDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _submit() async {
    final debtor = _debtor;
    if (debtor == null || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ref.read(debtorsSummaryControllerProvider.notifier).updateDebtor(
            debtorId: debtor.id,
            update: DebtorUpdate(
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              totalDebtAmount:
                  double.tryParse(_amountController.text.trim()) ?? 0,
              dueDate: _dueDate,
            ),
          );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debtor updated.')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit debtor'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
      ),
      body: _debtor == null
          ? const Center(child: Text('Debtor not found.'))
          : SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    AppTextField(
                      controller: _nameController,
                      labelText: 'Name',
                      validator: (value) => (value ?? '').trim().isEmpty
                          ? 'Name is required'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _phoneController,
                      labelText: 'Phone',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _amountController,
                      labelText: 'Total debt amount',
                      hintText: '0.00',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        final parsed = double.tryParse((value ?? '').trim());
                        if (parsed == null || parsed < 0) {
                          return 'Enter a valid amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: _dueDateController,
                      labelText: 'Due date (optional)',
                      hintText: 'Select a due date',
                      readOnly: true,
                      onTap: _pickDueDate,
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: _isSubmitting ? 'Saving...' : 'Save changes',
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
