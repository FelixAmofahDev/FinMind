import 'package:finmind/app/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../domain/entities/debtor.dart';
import '../providers/debtors_provider.dart';
import 'debtor_list_tile.dart';
import 'debtors_summary_card.dart';

/// Self-contained "Owes you" component. Fetches its own debtors summary and
/// renders the summary card plus the prioritised debtor list.
class DebtorsSection extends ConsumerWidget {
  const DebtorsSection({super.key, required this.onDebtorTap});

  final ValueChanged<Debtor> onDebtorTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryState = ref.watch(debtorsSummaryControllerProvider);

    return summaryState.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: LoadingIndicator(message: 'Loading debtors...'),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: EmptyStateWidget(
          icon: Icons.error_outline,
          title: 'Could not load debtors',
          message: error.toString(),
          action: TextButton(
            onPressed: () =>
                ref.read(debtorsSummaryControllerProvider.notifier).refresh(),
            child: const Text('Retry'),
          ),
        ),
      ),
      data: (summary) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DebtorsSummaryCard(
              totalOutstanding: summary.totalOutstanding,
              totalDebtorsCount: summary.totalDebtorsCount,
              overdueCount: summary.overdueCount,
            ),
            const SizedBox(height: 16),
            if (summary.debtors.isEmpty)
              const EmptyStateWidget(
                icon: Icons.people_outline,
                title: 'No debtors yet',
                message: 'People who owe you money will appear here.',
              )
            else ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 2),
                child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text(
      'MOST URGENT FIRST',
      style: TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: AppColors.mute,
      ),
    ),
    TextButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          AppRoutes.debtorsCreditorsHistory,
        );
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: const Text('View History'),
    ),
  ],
)
              ),
              //put view all button here that naviagtes to the debtors history page with owes you as active tab
             
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.line),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    for (int i = 0; i < summary.debtors.length; i++)
                      DebtorListTile(
                        debtor: summary.debtors[i],
                        showDivider: i != summary.debtors.length - 1,
                        onTap: () => onDebtorTap(summary.debtors[i]),
                      ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}