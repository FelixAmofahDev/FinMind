import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:finmind/features/reports/domain/entities/profit_loss_report.dart';
import 'package:finmind/features/reports/domain/entities/cash_position_report.dart';
import 'package:finmind/features/reports/presentation/widgets/cash_position_section.dart';
import 'package:finmind/features/reports/presentation/widgets/period_selector.dart';
import 'package:finmind/features/reports/presentation/widgets/pnl_breakdown_card.dart';
import 'package:finmind/shared/extensions/num_extensions.dart';
import 'package:finmind/shared/widgets/loading_indicator.dart';
import '../../../../app/router/routes.dart';
import '../providers/reports_provider.dart';

class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tab = ref.watch(reportTabProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: const Color(0xFFF4F7FB),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.trialBalance);
            },
            icon: const Icon(Icons.balance_rounded, size: 18),
            label: const Text('Get Trial Balance'),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (tab == ReportTab.profit) {
              await ref.read(profitLossControllerProvider.notifier).refresh();
            } else {
              await ref.read(cashPositionControllerProvider.notifier).refresh();
            }
          },
          child: ListView(
            padding: const EdgeInsets.only(bottom: 32),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 6),
              _buildTabControl(context, ref, tab),
              const SizedBox(height: 18),
              if (tab == ReportTab.profit)
                const _ProfitSection()
              else
                const _CashSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabControl(
      BuildContext context, WidgetRef ref, ReportTab tab) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EDF3),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'Profit',
              selected: tab == ReportTab.profit,
              onTap: () =>
                  ref.read(reportTabProvider.notifier).setTab(ReportTab.profit),
            ),
          ),
          Expanded(
            child: _TabButton(
              label: 'Cash',
              selected: tab == ReportTab.cash,
              onTap: () =>
                  ref.read(reportTabProvider.notifier).setTab(ReportTab.cash),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? const Color(0xFF185FA5) : const Color(0xFF46505F),
          ),
        ),
      ),
    );
  }
}

class _ProfitSection extends ConsumerWidget {
  const _ProfitSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preset = ref.watch(periodPresetProvider);
    final from = ref.watch(periodFromProvider);
    final to = ref.watch(periodToProvider);
    final profitState = ref.watch(profitLossControllerProvider);

    ref.listen<AsyncValue<ProfitLossReport>>(profitLossControllerProvider,
        (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load report: $error')),
          );
        },
      );
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: PeriodSelector(
            selectedPreset: preset,
            onPresetChanged: (value) {
              final range = _rangeForPreset(value);
              ref.read(periodPresetProvider.notifier).setPreset(value);
              if (range != null) {
                final fromStr = _formatDate(range.start);
                final toStr = _formatDate(range.end);
                ref.read(periodFromProvider.notifier).setFrom(fromStr);
                ref.read(periodToProvider.notifier).setTo(toStr);
              }
              ref
                  .read(profitLossControllerProvider.notifier)
                  .refresh();
            },
            customRange: (from.isNotEmpty && to.isNotEmpty)
                ? DateTimeRange(
                    start: DateTime.parse(from),
                    end: DateTime.parse(to),
                  )
                : null,
            onCustomRangeChanged: (range) {
              if (range != null) {
                final fromStr = _formatDate(range.start);
                final toStr = _formatDate(range.end);
                ref.read(periodFromProvider.notifier).setFrom(fromStr);
                ref.read(periodToProvider.notifier).setTo(toStr);
                ref.read(profitLossControllerProvider.notifier).refresh();
              }
            },
          ),
        ),
        const SizedBox(height: 24),
        profitState.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: LoadingIndicator(message: 'Loading report...'),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                'Could not load report',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
          data: (report) {
            final netIsPositive = report.netProfit >= 0;
            final periodLabel = _periodLabel(report.periodFrom, report.periodTo);

            return Column(
              children: [
                _BigFigure(
                  label: 'Net profit · $periodLabel',
                  value: report.netProfit.toCurrency(),
                  valueColor: netIsPositive
                      ? const Color(0xFF1D9E75)
                      : const Color(0xFFD05538),
                ),
                const SizedBox(height: 6),
                PnlBreakdownCard(report: report),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CashSection extends ConsumerWidget {
  const _CashSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cashState = ref.watch(cashPositionControllerProvider);

    ref.listen<AsyncValue<CashPositionReport>>(
        cashPositionControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load cash position: $error')),
          );
        },
      );
    });

    return cashState.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: LoadingIndicator(message: 'Loading cash position...'),
      ),
      error: (error, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Text(
            'Could not load cash position',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ),
      data: (report) {
        return Column(
          children: [
            _BigFigure(
              label: 'Total cash & balances',
              value: report.total.toCurrency(),
              valueColor: const Color(0xFF1A2230),
            ),
            const SizedBox(height: 6),
            CashPositionSection(report: report),
          ],
        );
      },
    );
  }
}

class _BigFigure extends StatelessWidget {
  const _BigFigure({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8893A2),
              letterSpacing: 0.04,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: valueColor,
              letterSpacing: -0.03,
            ),
          ),
        ],
      ),
    );
  }
}

DateTimeRange? _rangeForPreset(String preset) {
  switch (preset) {
    case 'this':
      return PeriodPreset.thisMonth();
    case 'last':
      return PeriodPreset.lastMonth();
    default:
      return null;
  }
}

String _formatDate(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String _periodLabel(String from, String to) {
  final fromDate = DateTime.tryParse(from);
  final toDate = DateTime.tryParse(to);
  if (fromDate == null || toDate == null) return 'this period';

  final now = DateTime.now();
  final thisMonthStart = DateTime(now.year, now.month, 1);
  final thisMonthEnd = now;

  final lastMonthEnd = thisMonthStart.subtract(const Duration(days: 1));
  final lastMonthStart = DateTime(lastMonthEnd.year, lastMonthEnd.month, 1);

  if (fromDate.year == thisMonthStart.year &&
      fromDate.month == thisMonthStart.month &&
      toDate.year == thisMonthEnd.year &&
      toDate.month == thisMonthEnd.month) {
    return DateFormat('MMMM').format(fromDate);
  }

  if (fromDate.year == lastMonthStart.year &&
      fromDate.month == lastMonthStart.month &&
      toDate.year == lastMonthEnd.year &&
      toDate.month == lastMonthEnd.month) {
    return DateFormat('MMMM').format(fromDate);
  }

  return '${DateFormat('d MMM').format(fromDate)} – ${DateFormat('d MMM yyyy').format(toDate)}';
}
