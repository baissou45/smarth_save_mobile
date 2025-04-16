import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TransactionCard extends StatelessWidget {
  final String? logo;
  final String? label;
  final String? date;
  final String? montant;
  final String? type;

  const TransactionCard({
    required this.logo, required this.label, required this.date, required this.montant, required this.type, super.key,
  });

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    var icon = type != 'Crédit'
        ? SvgPicture.asset(
            'assets/svg/debit.svg',
            color: Colors.red,
          )
        : SvgPicture.asset(
            'assets/svg/credit.svg',
            color: Colors.green,
          );
    return Container(
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    height: largeur / 10,
                    padding: const EdgeInsets.all(1),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(logo!),
                      // backgroundImage: NetworkImage(logo!),
                      radius: largeur / 15,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: largeur / 60),
                  Flexible(
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Évite l'expansion excessive
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: largeur / 3.5,
                          child: Text(
                            label!,
                            maxLines: 1, // Empêche le débordement vertical
                            overflow: TextOverflow
                                .ellipsis, // Coupe proprement si trop long
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          'Le $date',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],),
              ),
              SizedBox(
                width: largeur / 13,
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      icon,
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 45,
                        child: Text(
                          "${montant!.split("").join("")}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: type != 'Crédit' ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                      Text(
                        '€',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: type != 'Crédit' ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
