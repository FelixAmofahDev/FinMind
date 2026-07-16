import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/entities/creditor.dart';
import '../../domain/entities/creditor_update.dart';
import '../providers/creditors_provider.dart';

class CreditorEditPage extends ConsumerStatefulWidget {
  const CreditorEditPage({super.key});

  @override
  ConsumerState<CreditorEditPage> createState() => _CreditorEditPageState();
}

class _CreditorEditPageState extends ConsumerState<CreditorEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  Creditor? _creditor;
  bool _didInit = false;
  bool _isSubmitting = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic> && args['creditor'] is Creditor) {
        final creditor = args['creditor'] as Creditor;
        _creditor = creditor;
        _nameController.text = creditor.name;
        _phoneController.text = creditor.phone;
        _notesController.text = creditor.notes;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final creditor = _creditor;
    if (creditor == null || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ref
          .read(creditorsSummaryControllerProvider.notifier)
          .updateCreditor(
            creditorId: creditor.id,
            update: CreditorUpdate(
              name: _nameController.text.trim(),
              phone: _phoneController.text.trim(),
              notes: _notesController.text.trim().isEmpty
                  ? null
                  : _notesController.text.trim(),
            ),
          );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Creditor updated.')),
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
        title: const Text('Edit creditor'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
      ),
      body: _creditor == null
          ? const Center(child: Text('Creditor not found.'))
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
                      controller: _notesController,
                      labelText: 'Notes (optional)',
                      hintText: 'e.g. Supplies delivered every Monday',
                      maxLines: 3,
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
