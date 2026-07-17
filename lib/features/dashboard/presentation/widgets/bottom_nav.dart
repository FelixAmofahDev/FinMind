import 'package:finmind/app/router/routes.dart';
import 'package:flutter/material.dart';


class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavIcon(icon: Icons.home_filled, label: 'Home', selected: true, onTap: () {}),
            _NavIcon(icon: Icons.insights_outlined, label: 'Insights', onTap: () {}),
            const SizedBox(width: 40), // space for the notch/FAB
            _NavIcon(
              icon: Icons.people_outline,
              label: 'Money',
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.moneyPeopleHub),
            ),
            _NavIcon(icon: Icons.settings_outlined, label: 'Business', onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavIcon({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF185FA5) : Colors.grey.shade500;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 21, color: color),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}