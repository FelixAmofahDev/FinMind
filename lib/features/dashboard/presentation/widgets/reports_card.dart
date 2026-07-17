import 'package:flutter/material.dart';





class ReportCard extends StatelessWidget {
  const ReportCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF185FA5),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TODO: label for the primary metric
          Text('Cash on hand · all accounts',
              style: TextStyle(fontSize: 12.5, color: Colors.blue.shade100)),
          const SizedBox(height: 6),
          // TODO: bind to real amount (format with your currency helper)
          const Text('GHS 3,420.50',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5)),
          const SizedBox(height: 10),
          // TODO: trend chip — up/down vs last period
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Up GHS 480 this week',
                style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 14),
          // TODO: 2-column split under the hero (e.g. owed to you / you owe)
          Row(
            children: const [
              Expanded(child: _HeroSplitItem(label: 'Owed to you', value: 'GHS 1,240')),
              Expanded(child: _HeroSplitItem(label: 'You owe', value: 'GHS 600')),
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