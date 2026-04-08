import 'package:flutter/material.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';

class TransactionCard extends StatelessWidget {
  final String? logo;
  final String? label;
  final String? date;
  final dynamic montant;
  final String? type;

  const TransactionCard({
    super.key,
    required this.logo,
    required this.label,
    required this.date,
    required this.montant,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isCredit   = type == 'credit';
    final color      = isCredit ? kSuccess : kDanger;
    final amountText = '${isCredit ? '+' : '-'}$montant €';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Label + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label ?? 'Transaction',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kTextPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  date != null ? 'Le $date' : '',
                  style: const TextStyle(fontSize: 12, color: kTextSecondary),
                ),
              ],
            ),
          ),
          // Amount
          Text(
            amountText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
