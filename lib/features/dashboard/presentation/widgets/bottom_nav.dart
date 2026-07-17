import 'package:flutter/material.dart';

/// The destinations available from the dashboard's bottom navigation bar.
enum DashboardDestination {
  home('Home', Icons.home_filled),
  insights('Insights', Icons.insights_outlined),
  money('Money', Icons.people_outline),
  business('Business', Icons.settings_outlined);

  const DashboardDestination(this.label, this.icon);

  final String label;
  final IconData icon;
}

class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    const destinations = DashboardDestination.values;

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < destinations.length; i++)
              // space for the notch/FAB
            
              
                _NavIcon(
                  icon: destinations[i].icon,
                  label: destinations[i].label,
                  selected: i == selectedIndex,
                  onTap: () => onDestinationSelected(i),
                ),
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
