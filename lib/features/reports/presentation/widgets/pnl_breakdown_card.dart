import 'package:flutter/material.dart';
import 'package:finmind/shared/extensions/num_extensions.dart';
import '../../domain/entities/profit_loss_report.dart';

class PnlBreakdownCard extends StatelessWidget {
  const PnlBreakdownCard({
    super.key,
    required this.report,
  });

  final ProfitLossReport report;

  @override
  Widget build(BuildContext context) {
    final lines = <_PnlLine>[
      _PnlLine(label: 'Revenue', value: report.revenue, isTotal: false),
      _PnlLine(label: 'Cost of goods', value: report.cogs, isTotal: false),
      _PnlLine(
          label: 'Gross profit', value: report.grossProfit, isTotal: false),
      _PnlLine(label: 'Expenses', value: report.expenses, isTotal: false),
      _PnlLine(label: 'Net profit', value: report.netProfit, isTotal: true),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7EBF0)),
      ),
      child: Column(
        children: [
          for (int i = 0; i < lines.length; i++) ...[
            _PnlLineRow(line: lines[i]),
            if (i != lines.length - 1)
              const Divider(height: 1, color: Color(0xFFE7EBF0)),
          ],
          if (report.expenseBreakdown.isNotEmpty) ...[
            const Divider(height: 1, color: Color(0xFFE7EBF0)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Expenses',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF46505F),
                  ),
                ),
              ),
            ),
            ...report.expenseBreakdown.map(
              (item) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF46505F),
                        ),
                      ),
                    ),
                    Text(
                      item.amount.toCurrency(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A2230),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PnlLine {
  const _PnlLine({
    required this.label,
    required this.value,
    required this.isTotal,
  });

  final String label;
  final double value;
  final bool isTotal;
}

class _PnlLineRow extends StatelessWidget {
  const _PnlLineRow({required this.line});

  final _PnlLine line;

  @override
  Widget build(BuildContext context) {
    final valueColor = line.isTotal
        ? (line.value >= 0 ? const Color(0xFF1D9E75) : const Color(0xFFD05538))
        : const Color(0xFF1A2230);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              line.label,
              style: TextStyle(
                fontSize: line.isTotal ? 15 : 14,
                fontWeight: line.isTotal ? FontWeight.w700 : FontWeight.w500,
                color: line.isTotal
                    ? const Color(0xFF1A2230)
                    : const Color(0xFF46505F),
              ),
            ),
          ),
          Text(
            line.value.toCurrency(),
            style: TextStyle(
              fontSize: line.isTotal ? 16 : 14,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
