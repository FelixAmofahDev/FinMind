import 'package:finmind/features/dashboard/presentation/widgets/header.dart';
import 'package:finmind/features/dashboard/presentation/widgets/quick_action_grid.dart';
import 'package:finmind/features/dashboard/presentation/widgets/recent_activity.dart';
import 'package:finmind/features/dashboard/presentation/widgets/reports_card.dart';
import 'package:finmind/features/dashboard/presentation/widgets/stats_card.dart';
import 'package:flutter/material.dart';

/// The home screen shown when the dashboard's "Home" tab is selected.
/// Aggregates the greeting, cash-position hero, quick actions, this-month
/// stats and recent activity. The bottom navigation is owned by the
/// [DashboardPage] shell.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: const [
          DashboardHeader(),
          SizedBox(height: 6),
          ReportCard(),
          SizedBox(height: 18),
          QuickActionsGrid(),
          SizedBox(height: 18),
          StatCardsRow(),
          SizedBox(height: 20),
          _SectionHeader(title: 'Recent activity', actionLabel: 'See all'),
          ActivityListCard(),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ===========================================================================
// SECTION HEADER — reusable title + "see all" link
// ===========================================================================
class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  const _SectionHeader({required this.title, required this.actionLabel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          // TODO: onTap -> navigate to full list
          Text(
            actionLabel,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF185FA5)),
          ),
        ],
      ),
    );
  }
}
