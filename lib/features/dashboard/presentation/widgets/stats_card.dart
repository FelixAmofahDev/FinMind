import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finmind/shared/extensions/num_extensions.dart';
import '../../../../features/reports/presentation/providers/reports_provider.dart';

class StatCardsRow extends ConsumerWidget {
  const StatCardsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profitState = ref.watch(profitLossControllerProvider);

    final sales = profitState.value?.revenue ?? 0;
    final profit = profitState.value?.netProfit ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _StatCard(label: 'Sales', value: sales.toCurrency())),
          const SizedBox(width: 11),
          Expanded(child: _StatCard(label: 'Profit', value: profit.toCurrency())),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE7EBF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey.shade500)),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
