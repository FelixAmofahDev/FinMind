import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/dialogs/error_dialog.dart';
import '../../../../shared/dialogs/loading_dialog.dart';
import '../../domain/entities/product_import_result.dart';
import '../providers/products_provider.dart';

class ProductBulkImportPage extends ConsumerWidget {
  const ProductBulkImportPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk import products'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            AppCard(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Import products from a spreadsheet',
                    style: AppTextStyles.titleLarge.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Download the template, fill in your products in Excel or Google Sheets, then upload the file back here. Up to 500 products per upload.',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'Download template',
                    icon: const Icon(Icons.download_rounded, size: 20),
                    onPressed: () => _downloadTemplate(context, ref),
                    expanded: true,
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    label: 'Upload filled CSV',
                    icon: const Icon(Icons.upload_file_rounded, size: 20),
                    onPressed: () => _uploadCsv(context, ref),
                    expanded: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadTemplate(BuildContext context, WidgetRef ref) async {
    try {
      final bytes = await ref.read(productsControllerProvider.notifier).downloadImportTemplate();
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/finmind-product-template.csv');
      await file.writeAsBytes(bytes);
      if (!context.mounted) return;
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Fill this in and upload it back to FinMind',
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Template downloaded successfully.')),
      );
    } catch (error) {
      if (!context.mounted) return;
      ErrorDialog.show(
        context,
        message: error.toString(),
        title: 'Failed to download template',
      );
    }
  }

  Future<void> _uploadCsv(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (result == null || result.files.isEmpty) return;

      final picked = result.files.single;
      final file = File(picked.path!);
      if (!file.existsSync()) {
        ErrorDialog.show(
          context,
          message: 'Selected file could not be found.',
          title: 'File not found',
        );
        return;
      }

      if (!context.mounted) return;
      LoadingDialog.show(context, message: 'Importing products...');

      final importResult = await ref.read(productsControllerProvider.notifier).importProducts(csvFile: file);

      if (!context.mounted) return;
      LoadingDialog.hide(context);

      await _showResult(context, importResult);
    } catch (error) {
      if (!context.mounted) return;
      LoadingDialog.hide(context);
      ErrorDialog.show(
        context,
        message: error.toString(),
        title: 'Import failed',
      );
    }
  }

  Future<void> _showResult(BuildContext context, ProductImportResult result) async {
    final message = result.failed == 0
        ? '${result.created} products added successfully.'
        : '${result.created} products added. ${result.failed} rows had issues:';

    final theme = Theme.of(context);
    final errorItems = result.errors.isEmpty
        ? <Widget>[]
        : [
            const SizedBox(height: 12),
            Text(
              'Errors:',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            ...result.errors.map((error) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      size: 18,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Row ${error.row}: ',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: error.name.isNotEmpty ? '"${error.name}" — ' : '',
                              style: theme.textTheme.bodySmall,
                            ),
                            TextSpan(
                              text: error.reason,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ];

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message),
        ...errorItems,
      ],
    );

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: Icon(
            result.failed == 0
                ? Icons.check_circle_outline
                : Icons.warning_rounded,
            color: result.failed == 0
                ? theme.colorScheme.primary
                : theme.colorScheme.error,
            size: 32,
          ),
          title: Text(result.failed == 0 ? 'Import complete' : 'Import finished'),
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
