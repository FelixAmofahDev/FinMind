import '../../../creditors/domain/entities/creditors_summary.dart';
import '../../../debtors/domain/entities/debtors_summary.dart';
import '../../domain/entities/money_overview.dart';

/// Builds the merged [MoneyOverview] from the independent debtors and creditors
/// summaries owned by their respective features.
class MoneyOverviewModel extends MoneyOverview {
  const MoneyOverviewModel({
    required super.totalOwedToYou,
    required super.totalYouOwe,
  });

  factory MoneyOverviewModel.fromSummaries({
    required DebtorsSummary debtors,
    required CreditorsSummary creditors,
  }) {
    return MoneyOverviewModel(
      totalOwedToYou: debtors.totalOutstanding,
      totalYouOwe: creditors.totalOutstanding,
    );
  }
}
