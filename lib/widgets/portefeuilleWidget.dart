import 'package:flutter/material.dart';

class PortefeuilleWidget extends StatelessWidget {
  final String title;
  final int amount;
  final int actuelAmount;

  const PortefeuilleWidget({
    Key? key,
    required this.title,
    required this.amount,
    required this.actuelAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  double rawProgress = actuelAmount / amount;
  double clampedProgress = rawProgress.clamp(0.0, 1.0);
  
  Color progressColor;
  
  // Choisir la couleur selon le niveau de dépense
  if (rawProgress >= 1.0) {
    // Dépassement du budget
    progressColor = Colors.red;
  } else if (rawProgress >= 0.5) {
    // Presque au max
    progressColor = Colors.orange;
  } else {
    // En dessous de 70%
    progressColor = Colors.green;
  }
    return Container(
    width: 90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 5),
          
          Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color:Colors.black , width: 1.5), // ✅ Bordure
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: clampedProgress,
              backgroundColor: progressColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 8,
            ),
          ),
        ),
          
          const SizedBox(height: 5),
          Text(
            "$amount €",
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "$amount €",
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
  }
}
