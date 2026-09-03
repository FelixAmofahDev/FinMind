import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/colors.dart';
import '../../../audit_trail/domain/entities/audit_log.dart';

/// Renders a single [AuditLog] entry as a bright, modern event detail
/// screen: a gradient-tinted header identifying what happened, then an
/// adaptive grid of field tiles instead of a plain stacked list.
class AuditDetailPage extends StatelessWidget {
  const AuditDetailPage({super.key, required this.log});

  final AuditLog log;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entityColor = _entityColor(log.entity);
    final actionMeta = _actionMeta(log.action);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Audit details'),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
          children: [
            _Header(
              icon: _entityIcon(log.entity),
              entityColor: entityColor,
              actionColor: actionMeta.color,
              actionIcon: actionMeta.icon,
              action: log.action,
              summary: log.summary,
              entityLabel: _entityLabel(log.entity),
              createdAt: log.createdAt,
            ),
            const SizedBox(height: 20),
            _SectionLabel('Record', color: entityColor),
            const SizedBox(height: 10),
            _TileGrid(
              tiles: [
                _Tile(
                  icon: Icons.category_rounded,
                  label: 'Entity',
                  value: _entityLabel(log.entity),
                  accent: entityColor,
                  half: true,
                ),
                _Tile(
                  icon: Icons.schedule_rounded,
                  label: 'Date & time',
                  value: DateFormat('dd MMM, hh:mm a').format(log.createdAt),
                  accent: entityColor,
                  half: true,
                ),
                _Tile(
                  icon: Icons.tag_rounded,
                  label: 'Reference',
                  value: log.referenceNumber.isNotEmpty ? log.referenceNumber : '—',
                  accent: entityColor,
                  monospace: true,
                  onCopy: log.referenceNumber.isNotEmpty ? () => _copy(context, log.referenceNumber) : null,
                ),
                _Tile(
                  icon: Icons.fingerprint_rounded,
                  label: 'Entity ID',
                  value: log.entityId,
                  accent: entityColor,
                  monospace: true,
                  onCopy: () => _copy(context, log.entityId),
                ),
                _Tile(
                  icon: Icons.person_rounded,
                  label: 'Performed by',
                  value: log.actorId,
                  accent: entityColor,
                  monospace: true,
                  onCopy: () => _copy(context, log.actorId),
                ),
              ],
            ),
            if (log.details.isNotEmpty) ...[
              const SizedBox(height: 24),
              _SectionLabel('Additional details', color: entityColor),
              const SizedBox(height: 10),
              _TileGrid(
                tiles: log.details.entries.map((entry) {
                  final value = _formatValue(entry.value);
                  return _Tile(
                    label: _formatKey(entry.key),
                    value: value,
                    accent: entityColor,
                    half: value.length <= 8,
                    monospace: _looksLikeIdentifier(entry.value),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _copy(BuildContext context, String value) {
    if (value.isEmpty) return;
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard'), duration: Duration(seconds: 2), behavior: SnackBarBehavior.floating),
    );
  }

  bool _looksLikeIdentifier(dynamic value) {
    final str = value.toString();
    return str.length > 12 && !str.contains(' ');
  }

  String _formatValue(dynamic value) {
    if (value == null) return '—';
    if (value is bool) return value ? 'Yes' : 'No';
    final str = value.toString();
    if (str.isEmpty || str == 'null') return '—';
    return str;
  }

  /// Converts camelCase / snake_case keys into readable labels. Uses
  /// `replaceAllMapped` — plain `replaceAll` in Dart does not support
  /// `$1`-style regex backreferences.
  String _formatKey(String key) {
    final spaced = key
        .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m.group(1)} ${m.group(2)}')
        .replaceAll('_', ' ');
    final words = spaced.split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    return words.map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
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

  ({Color color, IconData icon}) _actionMeta(String action) {
    switch (action) {
      case 'created':
        return (color: AppColors.success, icon: Icons.add_circle_rounded);
      case 'updated':
        return (color: AppColors.blue, icon: Icons.edit_rounded);
      case 'voided':
        return (color: AppColors.warning, icon: Icons.block_rounded);
      case 'deleted':
        return (color: AppColors.danger, icon: Icons.delete_rounded);
      default:
        return (color: AppColors.mute, icon: Icons.history_rounded);
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

  String _entityLabel(String entity) {
    return entity
        .split('_')
        .map((word) => word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}

/// Gradient-tinted hero block: a bold icon badge, the summary as a big
/// headline, and an icon-led status pill.
class _Header extends StatelessWidget {
  const _Header({
    required this.icon,
    required this.entityColor,
    required this.actionColor,
    required this.actionIcon,
    required this.action,
    required this.summary,
    required this.entityLabel,
    required this.createdAt,
  });

  final IconData icon;
  final Color entityColor;
  final Color actionColor;
  final IconData actionIcon;
  final String action;
  final String summary;
  final String entityLabel;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [entityColor.withOpacity(0.16), entityColor.withOpacity(0.03)],
        ),
        border: Border.all(color: entityColor.withOpacity(0.14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [entityColor, entityColor.withOpacity(0.7)],
                  ),
                  boxShadow: [BoxShadow(color: entityColor.withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6))],
                ),
                child: Icon(icon, size: 24, color: Colors.white),
              ),
              const Spacer(),
              _StatusPill(label: action, color: actionColor, icon: actionIcon),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            summary,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, height: 1.3, letterSpacing: -0.2),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: entityColor.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  entityLabel,
                  style: theme.textTheme.labelSmall?.copyWith(color: entityColor, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.access_time_rounded, size: 13, color: AppColors.mute.withOpacity(0.8)),
              const SizedBox(width: 4),
              Text(
                DateFormat('dd MMM yyyy, hh:mm a').format(createdAt),
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.mute),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color, required this.icon});

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            label.isEmpty ? label : '${label[0].toUpperCase()}${label.substring(1)}',
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.2),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 4, height: 14, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(
          text.toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
              ),
        ),
      ],
    );
  }
}

/// Lays tiles out in a wrapping grid — half-width tiles pair up two to a
/// row, full-width ones (long IDs, references) take the whole row.
class _TileGrid extends StatelessWidget {
  const _TileGrid({required this.tiles});

  final List<_Tile> tiles;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final halfWidth = (constraints.maxWidth - 10) / 2;
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: tiles
              .map((tile) => SizedBox(
                    width: tile.half ? halfWidth : constraints.maxWidth,
                    child: tile,
                  ))
              .toList(),
        );
      },
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    this.icon,
    required this.label,
    required this.value,
    required this.accent,
    this.half = false,
    this.monospace = false,
    this.onCopy,
  });

  final IconData? icon;
  final String label;
  final String value;
  final Color accent;
  final bool half;
  final bool monospace;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.02),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: accent.withOpacity(0.9)),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(color: AppColors.mute, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontFamily: monospace ? 'monospace' : null,
                    fontSize: monospace ? 12.5 : null,
                    height: 1.3,
                  ),
                ),
              ),
              if (onCopy != null)
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: onCopy,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6, top: 1),
                    child: Icon(Icons.copy_rounded, size: 14, color: accent.withOpacity(0.7)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}