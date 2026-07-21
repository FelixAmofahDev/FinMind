import 'package:finmind/features/creditors/presentation/widgets/creditors_hostory_section.dart';
import 'package:finmind/features/debtors/presentation/widgets/debtors_history_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/app_segmented_control.dart';
import '../../../creditors/domain/entities/creditor.dart';
import '../../../creditors/presentation/providers/creditors_provider.dart';
import '../../../debtors/domain/entities/debtor.dart';
import '../../../debtors/presentation/providers/debtors_provider.dart';
import '../../domain/entities/money_people_tab.dart';
import '../providers/money_people_hub_provider.dart';

/// Central Money & People hub — a read-only aggregator and navigation gateway.
class MoneyPeopleHubHistoryPage extends ConsumerWidget {
  const MoneyPeopleHubHistoryPage({super.key});

  Future<void> _refresh(WidgetRef ref, MoneyPeopleTab tab) async {
    if (tab == MoneyPeopleTab.owesYou) {
      await ref.read(listDebtorsControllerProvider.notifier).refresh();
    } else {
      await ref.read(listCreditorsControllerProvider.notifier).refresh();
    }
  }

  void _openDebtor(BuildContext context, Debtor debtor) {
    Navigator.of(context).pushNamed(
      AppRoutes.recordRepayment,
      arguments: <String, dynamic>{'debtor': debtor},
    );
  }

  void _openCreditor(BuildContext context, Creditor creditor) {
    Navigator.of(context).pushNamed(
      AppRoutes.recordSupplierPayment,
      arguments: <String, dynamic>{'creditor': creditor},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(moneyPeopleTabProvider);
    final isOwesYou = tab == MoneyPeopleTab.owesYou;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Debtors & Creditors History'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refresh(ref, tab),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              
              
              AppSegmentedControl(
                segments: const ['Owes you', 'You owe'],
                selectedIndex: isOwesYou ? 0 : 1,
                onChanged: (index) {
                  ref.read(moneyPeopleTabProvider.notifier).select(
                        index == 0
                            ? MoneyPeopleTab.owesYou
                            : MoneyPeopleTab.youOwe,
                      );
                },
              ),
              const SizedBox(height: 18),
              // bring view all text button to the right of the section title
              if (isOwesYou)
                DebtorsHistorySection(
                  onDebtorTap: (debtor) => _openDebtor(context, debtor),
                )
              else
                CreditorsHistorySection(
                  onCreditorTap: (creditor) =>
                      _openCreditor(context, creditor),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
