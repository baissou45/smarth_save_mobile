import 'package:flutter/material.dart';

class BanqueCard extends StatelessWidget {
  final String logo;
  final String nom;

  const BanqueCard({
    required this.logo, required this.nom, super.key,
  });

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;

    return Container(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        elevation: 3.0,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: largeur / 40.0,
            horizontal: largeur / 40.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: largeur / 10.0,
                padding: const EdgeInsets.all(1),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  backgroundImage: AssetImage(logo),
                  radius: largeur / 15,
                  backgroundColor: Colors.white,
                ),
              ),
              Flexible(
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min, // Évite l'expansion excessive
                    crossAxisAlignment: CrossAxisAlignment.start,
                    
                    children: [
                      Text(
                        nom.split(' ').first,
                        maxLines: 1, // Empêche le débordement vertical
                        overflow: TextOverflow
                            .ellipsis, // Coupe proprement si trop long
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        nom.split(' ').skip(1).join(' '),
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
              
            ],
          ),
        ),
      ),
    );
  }
}
