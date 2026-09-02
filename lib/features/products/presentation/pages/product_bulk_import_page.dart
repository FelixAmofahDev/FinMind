import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/dialogs/error_dialog.dart';
import '../../../../shared/dialogs/loading_dialog.dart';
import '../../../../shared/utils/csv_import_utils.dart';
import '../../domain/entities/product_import_row.dart';
import '../../domain/entities/product_import_result.dart';
import '../../presentation/widgets/product_import_row.dart';
import '../providers/products_provider.dart';

class ProductBulkImportPage extends ConsumerStatefulWidget {
  const ProductBulkImportPage({super.key});

  @override
  ConsumerState<ProductBulkImportPage> createState() => _ProductBulkImportPageState();
}

class _ProductBulkImportPageState extends ConsumerState<ProductBulkImportPage> {
  final List<ProductImportRow> _rows = <ProductImportRow>[];
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk import products'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        actions: [
          if (_rows.isNotEmpty && !_isSubmitting)
            TextButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.upload_rounded, size: 18),
              label: const Text('Submit'),
            ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      
                      Expanded(
                        child: PrimaryButton(
                          label: 'Upload CSV',
                          icon: const Icon(Icons.upload_file_rounded, size: 18),
                          onPressed: _isSubmitting ? null : _uploadCsv,
                          //expanded: true,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: PrimaryButton(
                          label: 'Template',
                          icon: const Icon(Icons.download_rounded, size: 18),
                          onPressed: _downloadTemplate,
                          //expanded: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Add products manually, or upload a filled CSV template. Up to 500 products per submission.',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _rows.isEmpty
                  ? Center(
                      child: EmptyStateWidget(
                        icon: Icons.post_add_outlined,
                        title: 'No rows yet',
                        message: 'Add rows manually or upload a CSV template to get started.',
                        action: PrimaryButton(
                          label: 'Add first row',
                          onPressed: _addRow,
                          expanded: false,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: _rows.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _rows.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 8),
                            child: PrimaryButton(
                              label: 'Add another row',
                              icon: const Icon(Icons.add_rounded, size: 18),
                              onPressed: _addRow,
                              expanded: true,
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ProductImportRowWidget(
                            row: _rows[index],
                            index: index,
                            onChanged: (row) {
                              setState(() {
                                _rows[index] = row;
                              });
                            },
                            onRemove: () {
                              setState(() {
                                _rows.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _addRow() {
    setState(() {
      _rows.add(ProductImportRow());
    });
  }

  Future<void> _downloadTemplate() async {
    try {
      final bytes = await ref.read(productsControllerProvider.notifier).downloadImportTemplate();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/finmind-product-template.csv');
      await file.writeAsBytes(bytes);
      if (!mounted) return;
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Fill this in and upload it back to FinMind',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Template downloaded successfully.')),
      );
    } catch (error) {
      if (!mounted) return;
      ErrorDialog.show(
        context,
        message: error.toString(),
        title: 'Failed to download template',
      );
    }
  }

  Future<void> _uploadCsv() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );
      if (result == null || result.files.isEmpty) return;

      final picked = result.files.single;
      final extension = picked.extension?.toLowerCase() ?? picked.name.toLowerCase().split('.').last;
      if (extension != 'csv') {
        ErrorDialog.show(
          context,
          message: 'Please select a CSV file. Selected: ${picked.name}',
          title: 'Invalid file type',
        );
        return;
      }

      if (picked.path == null && picked.bytes == null) {
        ErrorDialog.show(
          context,
          message: 'Selected file could not be read. Try copying it to local storage first.',
          title: 'File not readable',
        );
        return;
      }

      String csvContent;
      if (picked.bytes != null) {
        csvContent = utf8.decode(picked.bytes!);
      } else {
        csvContent = await File(picked.path!).readAsString();
      }

      final parsedRows = CsvImportUtils.parseCsv(csvContent);
      if (parsedRows.isEmpty) {
        ErrorDialog.show(
          context,
          message: 'No valid product rows found in the CSV file.',
          title: 'Empty file',
        );
        return;
      }

      setState(() {
        _rows
          ..clear()
          ..addAll(parsedRows);
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loaded ${parsedRows.length} rows from CSV.')),
      );
    } catch (error) {
      if (!mounted) return;
      ErrorDialog.show(
        context,
        message: error.toString(),
        title: 'Failed to parse CSV',
      );
    }
  }

  Future<void> _submit() async {
    final nonEmptyRows = _rows.where((row) => row.name.trim().isNotEmpty).toList();
    if (nonEmptyRows.isEmpty) {
      ErrorDialog.show(
        context,
        message: 'Please add at least one product with a name.',
        title: 'No products to import',
      );
      return;
    }

    setState(() => _isSubmitting = true);
    LoadingDialog.show(context, message: 'Importing ${nonEmptyRows.length} products...');

    try {
      final csvContent = CsvImportUtils.generateCsv(nonEmptyRows);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/import-${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(csvContent);

      final result = await ref.read(productsControllerProvider.notifier).importProducts(csvFile: file);

      if (!mounted) return;
      LoadingDialog.hide(context);
      setState(() => _isSubmitting = false);

      if (result.failed == 0) {
        setState(() {
          _rows.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${result.created} products imported successfully.')),
        );
      } else {
        final erroredRows = _applyErrorsToRows(nonEmptyRows, result);
        setState(() {
          _rows
            ..clear()
            ..addAll(erroredRows);
        });
        await _showErrorResult(context, result);
      }
    } catch (error) {
      if (!mounted) return;
      LoadingDialog.hide(context);
      setState(() => _isSubmitting = false);
      ErrorDialog.show(
        context,
        message: error.toString(),
        title: 'Import failed',
      );
    }
  }

  List<ProductImportRow> _applyErrorsToRows(List<ProductImportRow> submittedRows, ProductImportResult result) {
    final errorByRow = <int, String>{};
    for (final error in result.errors) {
      errorByRow[error.row] = error.reason;
    }

    final erroredRows = <ProductImportRow>[];
    for (var i = 0; i < submittedRows.length; i++) {
      final originalRow = submittedRows[i];
      final backendRowNumber = i + 2;
      if (errorByRow.containsKey(backendRowNumber)) {
        erroredRows.add(originalRow.copyWith(error: errorByRow[backendRowNumber]));
      }
    }
    return erroredRows;
  }

  Future<void> _showErrorResult(BuildContext context, ProductImportResult result) async {
    final theme = Theme.of(context);
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${result.created} products added. ${result.failed} rows had issues and are highlighted below.'),
        const SizedBox(height: 12),
        ...result.errors.map((error) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_rounded, size: 16, color: theme.colorScheme.error),
                const SizedBox(width: 6),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Row ${error.row}: ',
                          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: error.name.isNotEmpty ? '"${error.name}" — ' : '',
                          style: theme.textTheme.bodySmall,
                        ),
                        TextSpan(text: error.reason, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Icon(Icons.warning_rounded, color: theme.colorScheme.error, size: 32),
          title: const Text('Import finished with errors'),
          content: SingleChildScrollView(child: content),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
