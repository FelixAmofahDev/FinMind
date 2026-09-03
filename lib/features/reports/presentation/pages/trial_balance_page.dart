import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/trial_balance_report.dart';
import '../providers/reports_provider.dart';
import '../../../../shared/widgets/loading_indicator.dart';

class TrialBalancePage extends ConsumerWidget {
  const TrialBalancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trialBalanceState = ref.watch(trialBalanceControllerProvider);

    ref.listen<AsyncValue<TrialBalanceReport>>(
        trialBalanceControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load trial balance: $error')),
          );
        },
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Trial Balance'),
        backgroundColor: const Color(0xFFF4F7FB),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(trialBalanceControllerProvider.notifier).refresh();
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(trialBalanceControllerProvider.notifier).refresh();
          },
          child: trialBalanceState.when(
            loading: () => const Center(
              child: LoadingIndicator(message: 'Loading trial balance...'),
            ),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Could not load trial balance',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref
                            .read(trialBalanceControllerProvider.notifier)
                            .refresh();
                      },
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
            data: (report) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'As of ${report.asOf.isNotEmpty ? report.asOf : 'today'}',
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF8893A2),
                              letterSpacing: 0.04,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: report.isBalanced
                                ? const Color(0xFF1D9E75)
                                : const Color(0xFFD05538),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            report.isBalanced ? 'Balanced' : 'Unbalanced',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        _buildTableHeader(),
                        const SizedBox(height: 8),
                        ...report.accounts.map((account) {
                          return _buildAccountRow(account);
                        }),
                        const SizedBox(height: 12),
                        _buildTotalRow(
                          'TOTAL',
                          report.totalDebit,
                          report.totalCredit,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EDF3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: const [
          Expanded(flex: 2, child: Text('Account')),
          Expanded(
            flex: 1,
            child: Text('Debit', textAlign: TextAlign.right),
          ),
          Expanded(
            flex: 1,
            child: Text('Credit', textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountRow(TrialBalanceAccount account) {
    final formatter = NumberFormat.currency(
      symbol: 'GHS ',
      decimalDigits: 2,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${account.code}  ${account.name}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A2230),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  account.type,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              account.debit > 0 ? formatter.format(account.debit) : '-',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: account.debit > 0 ? FontWeight.w600 : FontWeight.normal,
                color: account.debit > 0 ? const Color(0xFF1D9E75) : Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              account.credit > 0 ? formatter.format(account.credit) : '-',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    account.credit > 0 ? FontWeight.w600 : FontWeight.normal,
                color: account.credit > 0 ? const Color(0xFFD05538) : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, double totalDebit, double totalCredit) {
    final formatter = NumberFormat.currency(
      symbol: 'GHS ',
      decimalDigits: 2,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2230),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              formatter.format(totalDebit),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              formatter.format(totalCredit),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
