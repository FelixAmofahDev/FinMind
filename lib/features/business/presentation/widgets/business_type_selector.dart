import 'package:flutter/material.dart';

import '../../domain/entities/business_type.dart';

class BusinessTypeOption {
  const BusinessTypeOption({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final BusinessType type;
  final String title;
  final String subtitle;
  final IconData icon;
}

class BusinessTypeSelector extends StatelessWidget {
  const BusinessTypeSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<BusinessTypeOption> options;
  final BusinessType selected;
  final ValueChanged<BusinessType> onSelected;

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.25,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: options
          .map(
            (option) => _BusinessTypeCard(
              option: option,
              selected: option.type == selected,
              onTap: () => onSelected(option.type),
            ),
          )
          .toList(),
    );
  }
}

class _BusinessTypeCard extends StatelessWidget {
  const _BusinessTypeCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final BusinessTypeOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = selected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant;
    final backgroundColor = selected
        ? theme.colorScheme.primary.withValues(alpha: 0.06)
        : theme.colorScheme.surface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor, width: 1.3),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: selected ? 0.14 : 0.09),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(option.icon, color: theme.colorScheme.primary, size: 17),
                ),
                const Spacer(),
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? theme.colorScheme.primary : Colors.transparent,
                    border: Border.all(
                      color: selected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                      width: 1.8,
                    ),
                  ),
                  child: selected
                      ? Icon(Icons.check, size: 10, color: theme.colorScheme.onPrimary)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              option.title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
            const SizedBox(height: 3),
            Expanded(
              child: Text(
                option.subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 11,
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
