import 'package:finmind/app/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../domain/entities/creditor.dart';
import '../providers/creditors_provider.dart';
import 'creditor_list_tile.dart';
import 'creditors_summary_card.dart';

/// Self-contained "You owe" component. Fetches its own creditors summary and
/// renders the summary card plus the prioritised creditor list.
class CreditorsSection extends ConsumerWidget {
  const CreditorsSection({super.key, required this.onCreditorTap});

  final ValueChanged<Creditor> onCreditorTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryState = ref.watch(creditorsSummaryControllerProvider);

    return summaryState.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: LoadingIndicator(message: 'Loading creditors...'),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: EmptyStateWidget(
          icon: Icons.error_outline,
          title: 'Could not load creditors',
          message: error.toString(),
          action: TextButton(
            onPressed: () =>
                ref.read(creditorsSummaryControllerProvider.notifier).refresh(),
            child: const Text('Retry'),
          ),
        ),
      ),
      data: (summary) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreditorsSummaryCard(
              totalOutstanding: summary.totalOutstanding,
              totalCreditorsCount: summary.totalCreditorsCount,
              overdueCount: summary.overdueCount,
            ),
            const SizedBox(height: 16),
            if (summary.creditors.isEmpty)
              const EmptyStateWidget(
                icon: Icons.storefront_outlined,
                title: 'No creditors yet',
                message: 'Suppliers you owe money to will appear here.',
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
                          AppRoutes.moneyPeopleHubHistory,
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
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.line),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    for (int i = 0; i < summary.creditors.length; i++)
                      CreditorListTile(
                        creditor: summary.creditors[i],
                        showDivider: i != summary.creditors.length - 1,
                        onTap: () => onCreditorTap(summary.creditors[i]),
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
