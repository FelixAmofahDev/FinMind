import 'package:finmind/shared/widgets/quick_action.dart';
import 'package:flutter/material.dart';


class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    // TODO: replace this list with your real actions (icon, label, onTap)
    final actions = [
      QuickAction(icon: Icons.point_of_sale, label: 'Sell', onTap: () {}),
      QuickAction(icon: Icons.inventory_2_outlined, label: 'Restock', onTap: () {
        Navigator.of(context).pushNamed('/products');
      }),
      QuickAction(icon: Icons.people_outline, label: 'Money', onTap: () {}),
      QuickAction(icon: Icons.insights_outlined, label: 'Insights', onTap: () {}),
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

