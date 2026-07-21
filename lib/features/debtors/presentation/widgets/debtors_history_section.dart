import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/app_segmented_control.dart';
import '../../domain/entities/debtor.dart';
import '../providers/debtors_provider.dart';
import 'debtor_list_tile.dart';
import 'debtors_summary_card.dart';

class DebtorsHistorySection extends ConsumerStatefulWidget {
  const DebtorsHistorySection({super.key, required this.onDebtorTap});

  final ValueChanged<Debtor> onDebtorTap;

  @override
  ConsumerState<DebtorsHistorySection> createState() => _DebtorsHistorySectionState();
}

class _DebtorsHistorySectionState extends ConsumerState<DebtorsHistorySection> {
  final _searchController = TextEditingController();
  int _hasDebtIndex = 1;
  int _isActiveIndex = 1;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    ref.read(listDebtorsSearchProvider.notifier).setSearch(query);
    ref
        .read(listDebtorsControllerProvider.notifier)
        .refresh(search: query.isEmpty ? null : query);
  }

  void _onHasDebtChanged(int index) {
    setState(() => _hasDebtIndex = index);
    final value = index == 0 ? null : index == 1 ? true : false;
    ref.read(listDebtorsHasDebtProvider.notifier).setHasDebt(value);
    ref
        .read(listDebtorsControllerProvider.notifier)
        .refresh(hasDebt: value);
  }

  void _onIsActiveChanged(int index) {
    setState(() => _isActiveIndex = index);
    final value = index == 0 ? null : index == 1 ? true : false;
    ref.read(listDebtorsIsActiveProvider.notifier).setIsActive(value);
    ref
        .read(listDebtorsControllerProvider.notifier)
        .refresh(isActive: value);
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(listDebtorsControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search debtors...',
              prefixIcon: const Icon(Icons.search_outlined, size: 18),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.line),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.line),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DEBT STATUS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mute,
                ),
              ),
              const SizedBox(height: 6),
              AppSegmentedControl(
                segments: const ['All', 'With debt', 'Settled'],
                selectedIndex: _hasDebtIndex,
                onChanged: _onHasDebtChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STATUS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mute,
                ),
              ),
              const SizedBox(height: 6),
              AppSegmentedControl(
                segments: const ['All', 'Active', 'Archived'],
                selectedIndex: _isActiveIndex,
                onChanged: _onIsActiveChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        listState.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: LoadingIndicator(message: 'Loading debtors...'),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: EmptyStateWidget(
              icon: Icons.error_outline,
              title: 'Could not load debtors',
              message: error.toString(),
              action: TextButton(
                onPressed: () =>
                    ref.read(listDebtorsControllerProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ),
          ),
          data: (debtors) {
           

            return Column(
              children: [
              
                const SizedBox(height: 16),
                if (debtors.isEmpty)
                  const EmptyStateWidget(
                    icon: Icons.people_outline,
                    title: 'No debtors found',
                    message: 'Try adjusting your filters.',
                  )
                else ...[
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 2),
                    child: Text(
                      'MOST URGENT FIRST',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: AppColors.mute,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.line),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        for (int i = 0; i < debtors.length; i++)
                          DebtorListTile(
                            debtor: debtors[i],
                            showDivider: i != debtors.length - 1,
                            onTap: () => widget.onDebtorTap(debtors[i]),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
