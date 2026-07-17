import 'package:finmind/app/router/routes.dart';
import 'package:finmind/shared/widgets/quick_action.dart';
import 'package:flutter/material.dart';


class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: replace this list with your real actions (icon, label, onTap)
    final actions = [
      QuickAction(icon: Icons.point_of_sale, label: 'Sell', onTap: () {}),
      QuickAction(icon: Icons.inventory_2_outlined, label: 'Restock', onTap: () {
        Navigator.of(context).pushNamed('/products');
      }),
      QuickAction(
        icon: Icons.receipt_long_outlined,
        label: 'Expense',
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.expenses),
      ),
      QuickAction(
        icon: Icons.people_outline,
        label: 'Money',
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.moneyPeopleHub),
      ),
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

