import 'package:flutter/material.dart';
import 'package:finmind/shared/extensions/num_extensions.dart';
import '../../domain/entities/cash_position_report.dart';

class CashPositionSection extends StatelessWidget {
  const CashPositionSection({
    super.key,
    required this.report,
  });

  final CashPositionReport report;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 4, 20, 10),
          child: Text(
            'Where your money is',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF8893A2),
              letterSpacing: 0.04,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE7EBF0)),
          ),
          child: Column(
            children: [
              for (int i = 0; i < report.accounts.length; i++) ...[
                _CashAccountRow(account: report.accounts[i]),
                if (i != report.accounts.length - 1)
                  const Divider(height: 1, color: Color(0xFFE7EBF0)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CashAccountRow extends StatelessWidget {
  const _CashAccountRow({required this.account});

  final CashAccount account;

  @override
  Widget build(BuildContext context) {
    final iconData = _iconForSubtype(account.subtype);
    final iconColor = _colorForSubtype(account.subtype);
    final iconBg = _bgForSubtype(account.subtype);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(iconData, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.name,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A2230),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  _subtitleForSubtype(account.subtype),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8893A2),
                  ),
                ),
              ],
            ),
          ),
          Text(
            account.balance.toCurrency(),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A2230),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForSubtype(String subtype) {
    switch (subtype) {
      case 'cash_hand':
        return Icons.account_balance_wallet_outlined;
      case 'cash_momo_mtn':
      case 'cash_momo_telecel':
      case 'cash_momo_airtel':
        return Icons.phone_android_outlined;
      case 'cash_bank':
        return Icons.account_balance_outlined;
      default:
        return Icons.payments_outlined;
    }
  }

  Color _colorForSubtype(String subtype) {
    switch (subtype) {
      case 'cash_hand':
        return const Color(0xFF1D9E75);
      case 'cash_momo_mtn':
        return const Color(0xFFEF9F27);
      case 'cash_momo_telecel':
        return const Color(0xFF185FA5);
      case 'cash_momo_airtel':
        return const Color(0xFF534AB7);
      case 'cash_bank':
        return const Color(0xFF1D9E75);
      default:
        return const Color(0xFF8893A2);
    }
  }

  Color _bgForSubtype(String subtype) {
    switch (subtype) {
      case 'cash_hand':
        return const Color(0xFFE1F5EE);
      case 'cash_momo_mtn':
        return const Color(0xFFFAEEDA);
      case 'cash_momo_telecel':
        return const Color(0xFFE6F1FB);
      case 'cash_momo_airtel':
        return const Color(0xFFEEEDFE);
      case 'cash_bank':
        return const Color(0xFFE6F1FB);
      default:
        return const Color(0xFFF4F7FB);
    }
  }

  String _subtitleForSubtype(String subtype) {
    switch (subtype) {
      case 'cash_hand':
        return 'In the till';
      case 'cash_momo_mtn':
        return 'Mobile money';
      case 'cash_momo_telecel':
        return 'Mobile money';
      case 'cash_momo_airtel':
        return 'Mobile money';
      case 'cash_bank':
        return 'Bank account';
      default:
        return '';
    }
  }
}
