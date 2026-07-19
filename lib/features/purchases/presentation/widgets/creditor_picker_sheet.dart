import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/extensions/num_extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/app_segmented_control.dart';
import '../../../../features/creditors/domain/entities/creditor.dart';
import '../../../../features/creditors/presentation/providers/creditors_provider.dart';

class CreditorPickerSheet extends ConsumerWidget {
  const CreditorPickerSheet({super.key, required this.onSelected});

  final ValueChanged<Creditor> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(listCreditorsControllerProvider);

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
                  child: _CreditorSearchField(),
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
                child: LoadingIndicator(message: 'Loading suppliers...'),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: EmptyStateWidget(
                  icon: Icons.error_outline,
                  title: 'Could not load suppliers',
                  message: error.toString(),
                  action: TextButton(
                    onPressed: () =>
                        ref.read(listCreditorsControllerProvider.notifier).refresh(),
                    child: const Text('Retry'),
                  ),
                ),
              ),
              data: (creditors) {
                if (creditors.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: EmptyStateWidget(
                      icon: Icons.storefront_outlined,
                      title: 'No suppliers found',
                      message: 'Try adjusting your filters.',
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: creditors.length,
                  itemBuilder: (context, index) {
                    final creditor = creditors[index];
                    return _CreditorTile(
                      creditor: creditor,
                      onTap: () {
                        onSelected(creditor);
                        Navigator.of(context).pop();
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

class _CreditorSearchField extends ConsumerStatefulWidget {
  const _CreditorSearchField();

  @override
  ConsumerState<_CreditorSearchField> createState() => _CreditorSearchFieldState();
}

class _CreditorSearchFieldState extends ConsumerState<_CreditorSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(listCreditorsSearchProvider));
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
    ref.read(listCreditorsSearchProvider.notifier).setSearch(query);
    ref
        .read(listCreditorsControllerProvider.notifier)
        .refresh(search: query.isEmpty ? null : query);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Search suppliers...',
        prefixIcon: const Icon(Icons.search_outlined, size: 18),
        suffixIcon: ref.watch(listCreditorsSearchProvider).isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                onPressed: () {
                  _controller.clear();
                  ref.read(listCreditorsSearchProvider.notifier).setSearch('');
                  ref
                      .read(listCreditorsControllerProvider.notifier)
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
    final hasDebt = ref.watch(listCreditorsHasDebtProvider);
    int selectedIndex;
    if (hasDebt == null) {
      selectedIndex = 0;
    } else if (hasDebt == true) {
      selectedIndex = 1;
    } else {
      selectedIndex = 2;
    }

    return AppSegmentedControl(
      segments: const ['All', 'You owe', 'Settled'],
      selectedIndex: selectedIndex,
      onChanged: (index) {
        final value = index == 0 ? null : index == 1 ? true : false;
        ref.read(listCreditorsHasDebtProvider.notifier).setHasDebt(value);
        ref
            .read(listCreditorsControllerProvider.notifier)
            .refresh(hasDebt: value);
      },
    );
  }
}

class _StatusFilter extends ConsumerWidget {
  const _StatusFilter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isActive = ref.watch(listCreditorsIsActiveProvider);
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
        ref.read(listCreditorsIsActiveProvider.notifier).setIsActive(value);
        ref
            .read(listCreditorsControllerProvider.notifier)
            .refresh(isActive: value);
      },
    );
  }
}

class _CreditorTile extends StatelessWidget {
  const _CreditorTile({required this.creditor, required this.onTap});

  final Creditor creditor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final initial = creditor.name.trim().isNotEmpty
        ? creditor.name.trim()[0].toUpperCase()
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
                color: AppColors.coralLight,
                borderRadius: BorderRadius.circular(11),
              ),
              child: Text(
                initial,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.coralDark,
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
                    creditor.name,
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
                    creditor.phone.isEmpty ? 'No phone' : creditor.phone,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mute,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              creditor.amountOutstanding.toCurrency(),
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
