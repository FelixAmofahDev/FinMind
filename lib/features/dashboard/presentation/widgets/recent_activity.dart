import 'package:flutter/material.dart';


class ActivityListCard extends StatelessWidget {
  const ActivityListCard({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: replace with real list bound to your data source
    final items = [
      _ActivityRow(title: 'Sale · cash', subtitle: 'Today, 8:24 AM', amount: '+120.00', positive: true),
      _ActivityRow(title: 'Transport', subtitle: 'Today, 7:50 AM', amount: '−35.00', positive: false),
      _ActivityRow(title: 'Kofi paid his debt', subtitle: 'Yesterday', amount: '+200.00', positive: true),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7EBF0)),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final isLast = i == items.length - 1;
          return Container(
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(bottom: BorderSide(color: Color(0xFFE7EBF0))),
            ),
            child: items[i],
          );
        }),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final bool positive;
  const _ActivityRow({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // TODO: swap for an icon that matches the activity type
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: positive ? const Color(0xFFE1F5EE) : const Color(0xFFFAECE7),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Icon(
          positive ? Icons.arrow_upward : Icons.arrow_downward,
          size: 18,
          color: positive ? const Color(0xFF0F6E56) : const Color(0xFF993C1D),
        ),
      ),
      title: Text(title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
      trailing: Text(
        amount,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: positive ? const Color(0xFF0F6E56) : const Color(0xFF993C1D),
        ),
      ),
      onTap: () {}, // TODO: navigate to activity detail
    );
  }
}
