import 'package:flutter/material.dart';


class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    // TODO: replace this list with your real actions (icon, label, onTap)
    final actions = [
      _QuickAction(icon: Icons.point_of_sale, label: 'Sell', onTap: () {}),
      _QuickAction(icon: Icons.inventory_2_outlined, label: 'Restock', onTap: () {
        Navigator.of(context).pushNamed('/products');
      }),
      _QuickAction(icon: Icons.people_outline, label: 'Money', onTap: () {}),
      _QuickAction(icon: Icons.insights_outlined, label: 'Insights', onTap: () {}),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: actions
            .map((a) => Expanded(child: a))
            .toList(),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE7EBF0)),
              ),
              child: Icon(icon, size: 22, color: const Color(0xFF46505F)),
            ),
            const SizedBox(height: 7),
            Text(label,
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}