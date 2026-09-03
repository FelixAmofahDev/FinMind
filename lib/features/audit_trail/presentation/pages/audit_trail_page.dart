import 'package:finmind/app/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/colors.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../domain/entities/audit_log.dart';
import '../../domain/entities/audit_query.dart';
import '../providers/audit_trail_provider.dart';

class AuditTrailPage extends ConsumerStatefulWidget {
  const AuditTrailPage({super.key});

  @override
  ConsumerState<AuditTrailPage> createState() => _AuditTrailPageState();
}

class _AuditTrailPageState extends ConsumerState<AuditTrailPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(auditLogsControllerProvider.notifier).loadFirstPage();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_isFiltered) {
        final controller = ref.read(auditTrailControllerProvider.notifier);
        final state = ref.read(auditTrailControllerProvider);
        if (state.hasMore && !state.isLoadingMore) {
          controller.loadNextPage();
        }
      } else {
        final controller = ref.read(auditLogsControllerProvider.notifier);
        final state = ref.read(auditLogsControllerProvider);
        if (state.hasMore && !state.isLoadingMore) {
          controller.loadNextPage(const AuditQuery(limit: 20));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final generalState = ref.watch(auditLogsControllerProvider);
    final filteredState = ref.watch(auditTrailControllerProvider);
    final filters = ref.watch(auditTrailFiltersProvider);

    _isFiltered = filters.entity != null || filters.action != null || filters.from != null || filters.to != null;
    final state = _isFiltered ? filteredState : generalState;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit trail'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _FilterBar(
              filters: filters,
              onFiltersChanged: (query) {
                ref.read(auditTrailFiltersProvider.notifier).state = query;
                if (query.entity == null && query.action == null && query.from == null && query.to == null) {
                  ref.read(auditLogsControllerProvider.notifier).loadFirstPage();
                } else {
                  ref.read(auditTrailControllerProvider.notifier).applyFilters(query);
                }
              },
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  final currentFilters = ref.read(auditTrailFiltersProvider);
                  final isFilteredNow = currentFilters.entity != null || currentFilters.action != null || currentFilters.from != null || currentFilters.to != null;
                  if (isFilteredNow) {
                    await ref.read(auditTrailControllerProvider.notifier).applyFilters(currentFilters);
                  } else {
                    await ref.read(auditLogsControllerProvider.notifier).refresh();
                  }
                },
                child: _buildContent(state, _isFiltered),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(AuditLogsState state, bool isFiltered) {
    final logs = state.logs;
    if (state.isLoading && logs.isEmpty) {
      return const Center(child: LoadingIndicator(message: 'Loading audit trail...'));
    }
    if (logs.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 100),
          EmptyStateWidget(
            icon: Icons.history_outlined,
            title: 'No audit entries yet',
            message: 'Accounting and operational actions will appear here.',
          ),
        ],
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: logs.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= logs.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.4))),
          );
        }
        final log = logs[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _AuditLogTile(
            log: log,
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.auditDetail,
                arguments: log,
              );
            },
          ),
        );
      },
    );
  }
}

class _FilterBar extends ConsumerWidget {
  const _FilterBar({required this.filters, required this.onFiltersChanged});

  final AuditQuery filters;
  final ValueChanged<AuditQuery> onFiltersChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _FilterChip(
                  label: 'Entity',
                  value: filters.entity,
                  options: const [
                    _FilterOption(value: 'sale', label: 'Sale'),
                    _FilterOption(value: 'stock_purchase', label: 'Stock Purchase'),
                    _FilterOption(value: 'expense', label: 'Expense'),
                    _FilterOption(value: 'debtor_payment', label: 'Debtor Payment'),
                    _FilterOption(value: 'creditor_payment', label: 'Creditor Payment'),
                    _FilterOption(value: 'owner_deposit', label: 'Owner Deposit'),
                    _FilterOption(value: 'owner_withdrawal', label: 'Owner Withdrawal'),
                  ],
                  onSelected: (value) {
                    final newQuery = filters.copyWith(entity: value, page: 1);
                    onFiltersChanged(newQuery);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FilterChip(
                  label: 'Action',
                  value: filters.action,
                  options: const [
                    _FilterOption(value: 'created', label: 'Created'),
                    _FilterOption(value: 'updated', label: 'Updated'),
                    _FilterOption(value: 'voided', label: 'Voided'),
                    _FilterOption(value: 'deleted', label: 'Deleted'),
                  ],
                  onSelected: (value) {
                    final newQuery = filters.copyWith(action: value, page: 1);
                    onFiltersChanged(newQuery);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _DateField(
                  label: 'From',
                  date: filters.from,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: filters.from ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      final newQuery = filters.copyWith(from: picked, page: 1);
                      onFiltersChanged(newQuery);
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DateField(
                  label: 'To',
                  date: filters.to,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: filters.to ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      final newQuery = filters.copyWith(to: picked, page: 1);
                      onFiltersChanged(newQuery);
                    }
                  },
                ),
              ),
            ],
          ),
          if (filters.entity != null || filters.action != null || filters.from != null || filters.to != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  onFiltersChanged(const AuditQuery());
                },
                icon: const Icon(Icons.clear_rounded, size: 18),
                label: const Text('Clear filters'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.value,
    required this.options,
    required this.onSelected,
  });

  final String label;
  final String? value;
  final List<_FilterOption> options;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paper,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.mute,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const VerticalDivider(width: 16, thickness: 1),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                hint: Text(
                  'All',
                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.mute),
                ),
                items: [
                  const DropdownMenuItem<String>(value: null, child: Text('All')),
                  ...options.map((option) {
                    return DropdownMenuItem<String>(value: option.value, child: Text(option.label));
                  }),
                ],
                onChanged: onSelected,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterOption {
  const _FilterOption({required this.value, required this.label});
  final String value;
  final String label;
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.date, required this.onTap});

  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.paper,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                date != null ? DateFormat('dd MMM yyyy').format(date!) : label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: date != null ? AppColors.textPrimary : AppColors.mute,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.mute),
          ],
        ),
      ),
    );
  }
}

class _AuditLogTile extends StatelessWidget {
  const _AuditLogTile({required this.log, this.onTap});

  final AuditLog log;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final actionColor = _actionColor(log.action);

    return AppCard(
      padding: const EdgeInsets.all(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.paper,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.line),
              ),
              child: Icon(_entityIcon(log.entity), size: 18, color: AppColors.textPrimary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          log.summary,
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: Color.fromARGB(255, 46, 97, 60)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusChip(label: log.action, color: actionColor),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _entityLabel(log.entity),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _entityColor(log.entity),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat('dd MMM yyyy, hh:mm a').format(log.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.mute),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _entityLabel(String entity) {
    return entity
        .split('_')
        .map((word) => word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  Color _actionColor(String action) {
    switch (action) {
      case 'created':
        return AppColors.mute;
      case 'updated':
        return AppColors.blue;
      case 'voided':
        return AppColors.warning;
      case 'deleted':
        return AppColors.danger;
      default:
        return AppColors.mute;
    }
  }
Color _entityColor(String entity) {
    switch (entity) {
      case 'sale':
        return AppColors.teal;
      case 'stock_purchase':
        return AppColors.amber;
      case 'expense':
        return AppColors.coral;
      case 'debtor_payment':
        return AppColors.blue;
      case 'creditor_payment':
        return AppColors.purple;
      case 'owner_deposit':
        return AppColors.tealDark;
      case 'owner_withdrawal':
        return AppColors.coralDark;
      default:
        return AppColors.mute;
    }
  }
  IconData _entityIcon(String entity) {
    switch (entity) {
      case 'sale':
        return Icons.point_of_sale_rounded;
      case 'stock_purchase':
        return Icons.shopping_cart_rounded;
      case 'expense':
        return Icons.receipt_long_rounded;
      case 'debtor_payment':
        return Icons.payments_rounded;
      case 'creditor_payment':
        return Icons.account_balance_wallet_rounded;
      case 'owner_deposit':
        return Icons.savings_rounded;
      case 'owner_withdrawal':
        return Icons.account_balance_rounded;
      default:
        return Icons.history_rounded;
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label[0].toUpperCase() + label.substring(1),
        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.2),
      ),
    );
  }
}