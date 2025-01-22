// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BanqueCard extends StatelessWidget {
  String logo;
  String nom;

  BanqueCard({
    super.key,
    required this.logo,
    required this.nom,
  });

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double longeur = MediaQuery.of(context).size.width;

    return SizedBox(
      width: largeur / 1.7,
      child: Card(
        elevation: 8.0,
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: longeur / 20.0, horizontal: largeur / 30.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(logo),
                radius: largeur / 15,
              ),
              Text(
                nom,
                // softWrap: true,
                overflow: TextOverflow.clip,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
