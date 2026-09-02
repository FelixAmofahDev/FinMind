import 'package:finmind/app/router/routes.dart';
import 'package:finmind/features/dashboard/presentation/widgets/header.dart';
import 'package:finmind/features/dashboard/presentation/widgets/quick_action_grid.dart';
import 'package:finmind/features/dashboard/presentation/widgets/recent_activity.dart';
import 'package:finmind/features/dashboard/presentation/widgets/reports_card.dart';
import 'package:finmind/features/dashboard/presentation/widgets/stats_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    //wrap in refresh indicator to allow pull to refresh on all pages
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          // Implement refresh logic here
        
        },
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            DashboardHeader(),
          const SizedBox(height: 6),
          ReportCard(),
          const SizedBox(height: 18),
          QuickActionsGrid(),
          const SizedBox(height: 18),
          StatCardsRow(),
          const SizedBox(height: 20),
          _SectionHeader(
            title: 'Recent activity',
            actionLabel: 'See all',
            onActionTap: () => Navigator.of(context).pushNamed(AppRoutes.auditTrail),
          ),
          const ActivityListCard(),
          const SizedBox(height: 12),
        ],
      ),
    ));
  }
}

// ===========================================================================
// SECTION HEADER — reusable title + "see all" link
// ===========================================================================
class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback? onActionTap;
  const _SectionHeader({required this.title, required this.actionLabel, this.onActionTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          if (onActionTap != null)
            GestureDetector(
              onTap: onActionTap,
              child: Text(
                actionLabel,
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF185FA5)),
              ),
            )
          else
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
