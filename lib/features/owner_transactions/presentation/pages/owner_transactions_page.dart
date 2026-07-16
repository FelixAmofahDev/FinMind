import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/extensions/num_extensions.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../domain/entities/owner_transaction.dart';
import '../../domain/entities/owner_transaction_type.dart';
import '../providers/owner_transactions_provider.dart';
import '../widgets/owner_transaction_entry_sheet.dart';
import '../widgets/owner_transaction_list_tile.dart';

class OwnerTransactionsPage extends ConsumerStatefulWidget {
  const OwnerTransactionsPage({super.key, this.initialTab});

  final OwnerTransactionType? initialTab;

  @override
  ConsumerState<OwnerTransactionsPage> createState() =>
      _OwnerTransactionsPageState();
}

class _OwnerTransactionsPageState extends ConsumerState<OwnerTransactionsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex:
          widget.initialTab == OwnerTransactionType.withdrawal ? 1 : 0,
    );
    _tabController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  OwnerTransactionType get _currentType => _tabController.index == 0
      ? OwnerTransactionType.deposit
      : OwnerTransactionType.withdrawal;

  Future<void> _openEntrySheet() async {
    final created = await OwnerTransactionEntrySheet.show(
      context,
      type: _currentType,
    );
    if (created == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _currentType == OwnerTransactionType.deposit
                ? 'Deposit saved.'
                : 'Withdrawal saved.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDeposit = _currentType == OwnerTransactionType.deposit;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Owner transactions'),
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.blue,
          unselectedLabelColor: AppColors.mute,
          indicatorColor: AppColors.blue,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          tabs: const [
            Tab(text: 'Deposits'),
            Tab(text: 'Withdrawals'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openEntrySheet,
        backgroundColor: isDeposit ? AppColors.teal : AppColors.purple,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(isDeposit ? 'Add deposit' : 'Add withdrawal', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: const [
            _OwnerTransactionsList(type: OwnerTransactionType.deposit),
            _OwnerTransactionsList(type: OwnerTransactionType.withdrawal),
          ],
        ),
      ),
    );
  }
}

class _OwnerTransactionsList extends ConsumerWidget {
  const _OwnerTransactionsList({required this.type});

  final OwnerTransactionType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDeposit = type == OwnerTransactionType.deposit;
    final state = isDeposit
        ? ref.watch(ownerDepositsControllerProvider)
        : ref.watch(ownerWithdrawalsControllerProvider);
    Future<void> onRefresh() {
      return isDeposit
          ? ref.read(ownerDepositsControllerProvider.notifier).refresh()
          : ref.read(ownerWithdrawalsControllerProvider.notifier).refresh();
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: state.when(
        loading: () => const LoadingIndicator(message: 'Loading...'),
        error: (error, _) => ListView(
          children: [
            const SizedBox(height: 80),
            EmptyStateWidget(
              icon: Icons.error_outline,
              title: 'Could not load',
              message: error.toString(),
              action: TextButton(
                onPressed: onRefresh,
                child: const Text('Retry'),
              ),
            ),
          ],
        ),
        data: (items) => _buildContent(context, items, isDeposit),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<OwnerTransaction> items,
    bool isDeposit,
  ) {
    if (items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 100),
          EmptyStateWidget(
            icon: isDeposit
                ? Icons.savings_outlined
                : Icons.account_balance_wallet_outlined,
            title: isDeposit ? 'No deposits yet' : 'No withdrawals yet',
            message: isDeposit
                ? 'Capital you inject into the business will appear here.'
                : 'Money you take out for personal use will appear here.',
          ),
        ],
      );
    }

    final total = items.fold<double>(0, (sum, e) => sum + e.amount);
    final accent = isDeposit ? AppColors.tealDark : AppColors.purpleDark;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(19, 17, 19, 17),
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isDeposit ? 'Total deposited' : 'Total withdrawn',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                total.toCurrency(),
                style: const TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${items.length} ${items.length == 1 ? 'entry' : 'entries'}',
                style: const TextStyle(fontSize: 12.5, color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.line),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (int i = 0; i < items.length; i++)
                OwnerTransactionListTile(
                  transaction: items[i],
                  showDivider: i != items.length - 1,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
