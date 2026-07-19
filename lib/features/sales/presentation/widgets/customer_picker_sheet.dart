import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/extensions/num_extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/app_segmented_control.dart';
import '../../../../features/debtors/domain/entities/debtor.dart';
import '../../../../features/debtors/presentation/providers/debtors_provider.dart';

class CustomerPickerSheet extends ConsumerWidget {
  const CustomerPickerSheet({super.key, required this.onSelected});

  final ValueChanged<Debtor> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(listDebtorsControllerProvider);

    return Container(
      color: AppColors.background,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
        minHeight: MediaQuery.of(context).size.height * 0.5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.line,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: _CustomerSearchField(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
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
                      _DebtStatusFilter(),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
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
                      _StatusFilter(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Flexible(
            child: listState.when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: LoadingIndicator(message: 'Loading customers...'),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: EmptyStateWidget(
                  icon: Icons.error_outline,
                  title: 'Could not load customers',
                  message: error.toString(),
                  action: TextButton(
                    onPressed: () =>
                        ref.read(listDebtorsControllerProvider.notifier).refresh(),
                    child: const Text('Retry'),
                  ),
                ),
              ),
              data: (debtors) {
                if (debtors.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: EmptyStateWidget(
                      icon: Icons.people_outline,
                      title: 'No customers found',
                      message: 'Try adjusting your filters.',
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: debtors.length,
                  itemBuilder: (context, index) {
                    final debtor = debtors[index];
                    return _CustomerTile(
                      debtor: debtor,
                      onTap: () {
                        onSelected(debtor);
                        Navigator.of(context).pop(debtor);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerSearchField extends ConsumerStatefulWidget {
  const _CustomerSearchField();

  @override
  ConsumerState<_CustomerSearchField> createState() => _CustomerSearchFieldState();
}

class _CustomerSearchFieldState extends ConsumerState<_CustomerSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(listDebtorsSearchProvider));
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _controller.text.trim();
    ref.read(listDebtorsSearchProvider.notifier).setSearch(query);
    ref
        .read(listDebtorsControllerProvider.notifier)
        .refresh(search: query.isEmpty ? null : query);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Search customers...',
        prefixIcon: const Icon(Icons.search_outlined, size: 18),
        suffixIcon: ref.watch(listDebtorsSearchProvider).isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                onPressed: () {
                  _controller.clear();
                  ref.read(listDebtorsSearchProvider.notifier).setSearch('');
                  ref
                      .read(listDebtorsControllerProvider.notifier)
                      .refresh(search: null);
                },
              )
            : null,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}

class _DebtStatusFilter extends ConsumerWidget {
  const _DebtStatusFilter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasDebt = ref.watch(listDebtorsHasDebtProvider);
    int selectedIndex;
    if (hasDebt == null) {
      selectedIndex = 0;
    } else if (hasDebt == true) {
      selectedIndex = 1;
    } else {
      selectedIndex = 2;
    }

    return AppSegmentedControl(
      segments: const ['All', 'Owing', 'Settled'],
      selectedIndex: selectedIndex,
      onChanged: (index) {
        final value = index == 0 ? null : index == 1 ? true : false;
        ref.read(listDebtorsHasDebtProvider.notifier).setHasDebt(value);
        ref
            .read(listDebtorsControllerProvider.notifier)
            .refresh(hasDebt: value);
      },
    );
  }
}

class _StatusFilter extends ConsumerWidget {
  const _StatusFilter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(listDebtorsIsActiveProvider);
    int selectedIndex;
    if (isActive == null) {
      selectedIndex = 0;
    } else if (isActive == true) {
      selectedIndex = 1;
    } else {
      selectedIndex = 2;
    }

    return AppSegmentedControl(
      segments: const ['All', 'Active', 'Archived'],
      selectedIndex: selectedIndex,
      onChanged: (index) {
        final value = index == 0 ? null : index == 1 ? true : false;
        ref.read(listDebtorsIsActiveProvider.notifier).setIsActive(value);
        ref
            .read(listDebtorsControllerProvider.notifier)
            .refresh(isActive: value);
      },
    );
  }
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({required this.debtor, required this.onTap});

  final Debtor debtor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final initial = debtor.name.trim().isNotEmpty
        ? debtor.name.trim()[0].toUpperCase()
        : '?';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.blueLight,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text(
                initial,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.blueDark,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    debtor.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    debtor.phone.isEmpty ? 'No phone' : debtor.phone,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mute,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              debtor.amountOutstanding.toCurrency(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.coralDark,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.mute,
            ),
          ],
        ),
      ),
    );
  }
}
