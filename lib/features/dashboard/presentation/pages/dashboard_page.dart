import 'package:finmind/features/ai/presentation/pages/conversations_list_page.dart';
import 'package:finmind/features/business/presentation/pages/business_profile_page.dart';
import 'package:finmind/features/dashboard/presentation/widgets/bottom_nav.dart';
import 'package:finmind/features/money_people_hub/presentation/pages/money_people_hub_page.dart';
import 'package:finmind/features/reports/presentation/pages/insights_page.dart';
import 'package:finmind/features/dashboard/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

/// Dashboard shell. Hosts the responsive bottom navigation and swaps the
/// active screen based on the selected destination:
///   Home → [HomePage], Insights → [InsightsPage],
///   AI → [ConversationsListPage], Money → [MoneyPeopleHubPage],
///   Business → [BusinessProfilePage].
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onDestinationSelected(int index) {
    if (_selectedIndex == index) {
      return;
    }
    setState(() => _selectedIndex = index);
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const InsightsPage();
      case 2:
        return const ConversationsListPage();
      case 3:
        return const MoneyPeopleHubPage();
      case 4:
        return const BusinessProfilePage();
      default:
        return const HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      body: _buildBody(),
      bottomNavigationBar: DashboardBottomNav(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
    );
  }
}
