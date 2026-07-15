import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../creditors/presentation/providers/creditors_provider.dart';
import '../../../debtors/presentation/providers/debtors_provider.dart';
import '../../data/models/money_overview_model.dart';
import '../../domain/entities/money_overview.dart';
import '../../domain/entities/money_people_tab.dart';

/// Currently selected hub tab (Owes you / You owe).
final moneyPeopleTabProvider =
    NotifierProvider<MoneyPeopleTabNotifier, MoneyPeopleTab>(
  MoneyPeopleTabNotifier.new,
);

class MoneyPeopleTabNotifier extends Notifier<MoneyPeopleTab> {
  @override
  MoneyPeopleTab build() => MoneyPeopleTab.owesYou;

  void select(MoneyPeopleTab tab) => state = tab;
}

/// Read-only merged overview aggregated from the debtors and creditors
/// summaries. Each underlying summary is still fetched by its own feature.
final moneyOverviewProvider = Provider<MoneyOverview>((ref) {
  final debtors = ref.watch(debtorsSummaryControllerProvider).value;
  final creditors = ref.watch(creditorsSummaryControllerProvider).value;

  if (debtors == null || creditors == null) {
    return MoneyOverview.empty;
  }

  return MoneyOverviewModel.fromSummaries(
    debtors: debtors,
    creditors: creditors,
  );
});
