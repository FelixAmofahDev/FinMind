import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/app_segmented_control.dart';
import '../../domain/entities/creditor.dart';
import '../providers/creditors_provider.dart';
import 'creditor_list_tile.dart';
import 'creditors_summary_card.dart';

class CreditorsHistorySection extends ConsumerStatefulWidget {
  const CreditorsHistorySection({super.key, required this.onCreditorTap});

  final ValueChanged<Creditor> onCreditorTap;

  @override
  ConsumerState<CreditorsHistorySection> createState() => _CreditorsHistorySectionState();
}

class _CreditorsHistorySectionState extends ConsumerState<CreditorsHistorySection> {
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
    ref.read(listCreditorsSearchProvider.notifier).setSearch(query);
    ref
        .read(listCreditorsControllerProvider.notifier)
        .refresh(search: query.isEmpty ? null : query);
  }

  void _onHasDebtChanged(int index) {
    setState(() => _hasDebtIndex = index);
    final value = index == 0 ? null : index == 1 ? true : false;
    ref.read(listCreditorsHasDebtProvider.notifier).setHasDebt(value);
    ref
        .read(listCreditorsControllerProvider.notifier)
        .refresh(hasDebt: value);
  }

  void _onIsActiveChanged(int index) {
    setState(() => _isActiveIndex = index);
    final value = index == 0 ? null : index == 1 ? true : false;
    ref.read(listCreditorsIsActiveProvider.notifier).setIsActive(value);
    ref
        .read(listCreditorsControllerProvider.notifier)
        .refresh(isActive: value);
  }

  @override
  Widget build(BuildContext context) {
    final listState = ref.watch(listCreditorsControllerProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search creditors...',
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
                segments: const ['All', 'You owe', 'Settled'],
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
            child: LoadingIndicator(message: 'Loading creditors...'),
          ),
          error: (error, _) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: EmptyStateWidget(
              icon: Icons.error_outline,
              title: 'Could not load creditors',
              message: error.toString(),
              action: TextButton(
                onPressed: () =>
                    ref.read(listCreditorsControllerProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ),
          ),
          data: (creditors) {
            //use the creditor summary ontroller instead
           

            return Column(
              children: [
               
                const SizedBox(height: 16),
                if (creditors.isEmpty)
                  const EmptyStateWidget(
                    icon: Icons.storefront_outlined,
                    title: 'No creditors found',
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
                        for (int i = 0; i < creditors.length; i++)
                          CreditorListTile(
                            creditor: creditors[i],
                            showDivider: i != creditors.length - 1,
                            onTap: () => widget.onCreditorTap(creditors[i]),
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
