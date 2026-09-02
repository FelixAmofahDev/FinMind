import 'package:finmind/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finmind/shared/extensions/num_extensions.dart';
import '../../../../features/debtors/presentation/providers/debtors_provider.dart';
import '../../../../features/creditors/presentation/providers/creditors_provider.dart';
import '../../../../features/reports/presentation/providers/reports_provider.dart';

class ReportCard extends ConsumerWidget {
  const ReportCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cashState = ref.watch(cashPositionControllerProvider);
    final debtorsState = ref.watch(debtorsSummaryControllerProvider);
    final creditorsState = ref.watch(creditorsSummaryControllerProvider);

    final cashTotal = cashState.value?.total ?? 0;
    final owedToYou = debtorsState.value?.totalOutstanding ?? 0;
    final youOwe = creditorsState.value?.totalOutstanding ?? 0;

    final cashText = cashTotal.toCurrency();
    final owedText = owedToYou.toCurrency();
    final oweText = youOwe.toCurrency();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Total cash · all accounts',
              style: TextStyle(fontSize: 12.5, color: Colors.blue.shade100)),
          const SizedBox(height: 6),
          Text(cashText,
              style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5)),
          
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _HeroSplitItem(label: 'Owed to you', value: owedText)),
              Expanded(child: _HeroSplitItem(label: 'You owe', value: oweText)),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroSplitItem extends StatelessWidget {
  final String label;
  final String value;
  const _HeroSplitItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11.5, color: Colors.blue.shade100)),
        const SizedBox(height: 3),
        Text(value,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
      ],
    );
  }
}
