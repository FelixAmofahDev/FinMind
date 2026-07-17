import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/reports_remote_datasource.dart';
import '../../data/repositories/reports_repository_impl.dart';
import '../../domain/entities/cash_position_report.dart';
import '../../domain/entities/profit_loss_report.dart';
import '../../domain/repositories/reports_repository.dart';
import '../../domain/usecases/get_cash_position.dart';
import '../../domain/usecases/get_profit_loss.dart';
import '../widgets/period_selector.dart';

final reportsRemoteDatasourceProvider =
    Provider<ReportsRemoteDatasource>((ref) {
  return ReportsRemoteDatasource(ref.read(apiClientProvider));
});

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepositoryImpl(
    remoteDatasource: ref.read(reportsRemoteDatasourceProvider),
  );
});

final getProfitLossUseCaseProvider = Provider<GetProfitLoss>((ref) {
  return GetProfitLoss(ref.read(reportsRepositoryProvider));
});

final getCashPositionUseCaseProvider = Provider<GetCashPosition>((ref) {
  return GetCashPosition(ref.read(reportsRepositoryProvider));
});

class ReportTabNotifier extends Notifier<ReportTab> {
  @override
  ReportTab build() => ReportTab.profit;

  void setTab(ReportTab tab) => state = tab;
}

final reportTabProvider = NotifierProvider<ReportTabNotifier, ReportTab>(
  ReportTabNotifier.new,
);

class PeriodPresetNotifier extends Notifier<String> {
  @override
  String build() => 'this';

  void setPreset(String preset) => state = preset;
}

final periodPresetProvider = NotifierProvider<PeriodPresetNotifier, String>(
  PeriodPresetNotifier.new,
);

class PeriodFromNotifier extends Notifier<String> {
  @override
  String build() {
    final range = PeriodPreset.thisMonth();
    return _formatDate(range.start);
  }

  void setFrom(String from) => state = from;
}

final periodFromProvider = NotifierProvider<PeriodFromNotifier, String>(
  PeriodFromNotifier.new,
);

class PeriodToNotifier extends Notifier<String> {
  @override
  String build() {
    final range = PeriodPreset.thisMonth();
    return _formatDate(range.end);
  }

  void setTo(String to) => state = to;
}

final periodToProvider = NotifierProvider<PeriodToNotifier, String>(
  PeriodToNotifier.new,
);

final profitLossControllerProvider =
    AsyncNotifierProvider<ProfitLossController, ProfitLossReport>(
  ProfitLossController.new,
);

class ProfitLossController extends AsyncNotifier<ProfitLossReport> {
  @override
  Future<ProfitLossReport> build() async {
    final from = ref.read(periodFromProvider);
    final to = ref.read(periodToProvider);
    return ref.watch(getProfitLossUseCaseProvider)(from: from, to: to);
  }

  Future<void> refresh({String? from, String? to}) async {
    if (from != null) ref.read(periodFromProvider.notifier).setFrom(from);
    if (to != null) ref.read(periodToProvider.notifier).setTo(to);
    ref.invalidateSelf();
    await future;
  }
}

final cashPositionControllerProvider =
    AsyncNotifierProvider<CashPositionController, CashPositionReport>(
  CashPositionController.new,
);

class CashPositionController extends AsyncNotifier<CashPositionReport> {
  @override
  Future<CashPositionReport> build() async {
    return ref.watch(getCashPositionUseCaseProvider)();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

String _formatDate(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
