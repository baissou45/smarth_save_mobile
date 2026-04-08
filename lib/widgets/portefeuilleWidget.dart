import 'package:flutter/material.dart';

class PortefeuilleWidget extends StatelessWidget {
  final String title;
  final int amount;
  final int actuelAmount;

  const PortefeuilleWidget({
    super.key,
    required this.title,
    required this.amount,
    required this.actuelAmount,
  });

  @override
  Widget build(BuildContext context) {
    double rawProgress = actuelAmount / amount;
  double clampedProgress = rawProgress.clamp(0.0, 1.0);

    Color progressColor;
    if (rawProgress >= 1.0) {
      progressColor = Colors.red;
    } else if (rawProgress >= 0.7) {
      progressColor = Colors.orange;
    } else {
      progressColor = const Color(0xFF0F766E);
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: clampedProgress,
              backgroundColor: progressColor.withOpacity(0.18),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 8,
            ),
          ),
          const Spacer(),
          Text(
            '$actuelAmount € / $amount €',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF374151),
              fontWeight: FontWeight.w600,
            ),
          ),
          // const SizedBox(height: 2),
          // Text(
          //   'Budget: $amount €',
          //   style: const TextStyle(
          //     fontSize: 11,
          //     color: Color(0xFF6B7280),
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
        ],
      ),
    );
  }
}
