import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ReportTab { profit, cash }

class PeriodPreset {
  const PeriodPreset._();

  static DateTimeRange thisMonth() {
    final now = DateTime.now();
    final first = DateTime(now.year, now.month, 1);
    return DateTimeRange(start: first, end: now);
  }

  static DateTimeRange lastMonth() {
    final now = DateTime.now();
    final firstThisMonth = DateTime(now.year, now.month, 1);
    final lastLastMonth = firstThisMonth.subtract(const Duration(days: 1));
    final firstLastMonth = DateTime(lastLastMonth.year, lastLastMonth.month, 1);
    return DateTimeRange(start: firstLastMonth, end: lastLastMonth);
  }
}

class PeriodSelector extends ConsumerWidget {
  const PeriodSelector({
    super.key,
    required this.selectedPreset,
    required this.onPresetChanged,
    this.customRange,
    this.onCustomRangeChanged,
  });

  final String selectedPreset;
  final ValueChanged<String> onPresetChanged;
  final DateTimeRange? customRange;
  final ValueChanged<DateTimeRange?>? onCustomRangeChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presets = const ['this', 'last', 'custom'];
    final labels = const ['This month', 'Last month', 'Custom'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(presets.length, (index) {
            final isSelected = selectedPreset == presets[index];
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (presets[index] == 'custom') {
                    _pickCustomRange(context);
                  }
                  onPresetChanged(presets[index]);
                },
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 6,
                    right: index == presets.length - 1 ? 0 : 6,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isSelected
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
                    labels[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF185FA5)
                          : const Color(0xFF46505F),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        if (selectedPreset == 'custom') ...[
          const SizedBox(height: 14),
          _CustomDateRangePicker(
            initialRange: customRange,
            onRangeChanged: onCustomRangeChanged,
          ),
        ],
      ],
    );
  }

  Future<void> _pickCustomRange(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: customRange ??
          DateTimeRange(
            start: DateTime(now.year, now.month, 1),
            end: now,
          ),
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      onCustomRangeChanged?.call(picked);
    }
  }
}

class _CustomDateRangePicker extends StatelessWidget {
  const _CustomDateRangePicker({
    required this.initialRange,
    required this.onRangeChanged,
  });

  final DateTimeRange? initialRange;
  final ValueChanged<DateTimeRange?>? onRangeChanged;

  @override
  Widget build(BuildContext context) {
    final from = initialRange?.start;
    final to = initialRange?.end;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7EBF0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _DateField(
              label: 'From',
              date: from,
              onTap: () => _pick(context, isStart: true),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _DateField(
              label: 'To',
              date: to,
              onTap: () => _pick(context, isStart: false),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pick(BuildContext context, {required bool isStart}) async {
    final now = DateTime.now();
    final currentRange = initialRange ??
        DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: now,
        );

    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? currentRange.start : currentRange.end,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      final newRange = DateTimeRange(
        start: isStart ? picked : currentRange.start,
        end: isStart ? currentRange.end : picked,
      );
      if (newRange.start.isAfter(newRange.end)) {
        final swapped = DateTimeRange(start: newRange.end, end: newRange.start);
        onRangeChanged?.call(swapped);
      } else {
        onRangeChanged?.call(newRange);
      }
    }
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8893A2),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE7EBF0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date != null
                        ? '${date!.day} ${_monthShort(date!)} ${date!.year}'
                        : 'Select date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: date != null
                          ? const Color(0xFF1A2230)
                          : const Color(0xFFAAB4C2),
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today_outlined,
                    size: 16, color: Color(0xFF8893A2)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _monthShort(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[date.month - 1];
  }
}
