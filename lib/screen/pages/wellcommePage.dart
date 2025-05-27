import 'package:flutter/material.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/screen/pages/notificationPage.dart';
import 'package:smarth_save/widgets/naveBar.dart';
import 'package:smarth_save/widgets/banque_card.dart';
import 'package:go_router/go_router.dart';

class Wellcommepage extends StatefulWidget {
  const Wellcommepage({super.key});

  @override
  State<Wellcommepage> createState() => _WellcommepageState();
}

class _WellcommepageState extends State<Wellcommepage> {
  var montant = "1095,02";
  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor1,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bienvenue",
              style: TextStyle(
                  fontSize: largeur / 30,
                  color: Colors.white,
                  fontWeight: FontWeight.normal),
            ),
            Text(
              "${UserModel.sessionUser?.prenom ?? ""} ${UserModel.sessionUser?.nom ?? ""}",
              style: TextStyle(fontSize: largeur / 20, color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                GoRouter.of(context).push('/notification');
              },
              icon: Container(
                width: 45,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26, // Couleur de l'ombre
                      blurRadius: 10, // Flou de l'ombre
                      spreadRadius: 2, // Expansion de l'ombre
                      offset: Offset(4, 4), // Décalage de l'ombre
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30, // Ajuste la taille
                  child: Icon(Icons
                      .notifications_active_outlined), // Utilisation directe du widget SVG ou icône
                ),
              )),
         
         
              // IconButton(
          //   onPressed: ()   {
          //     Scaffold.of(context).openDrawer(); // Ouvrir le drawer
          //   },
          //   icon: CircleAvatar(
          //     radius: largeur / 10,
          //     backgroundImage: AssetImage('assets/images/image_one.png'),
          //   ),
          // )
        ],
      ),
      drawer: Navebar(),
      body: Container(
        child: Column(children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Container vert (background)
              Container(
                color: kPrimaryColor1,
                height: hauteur / 5,
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(height: largeur / 20),
                    Text(
                      "${montant.split("").join("")} €",
                      style: TextStyle(
                        fontSize: largeur / 10,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: hauteur / 60),
                    Text(
                      "Solde",
                      style: TextStyle(
                          fontSize: largeur / 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              // Conteneur pour le reste
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(8, 8),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(10),
                margin:
                    EdgeInsets.only(top: hauteur / 5 - 30, left: 10, right: 10),
                child: Container(
                  // padding: EdgeInsets.all(hauteur / 100),
                  height: hauteur / 6,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        child: Text(
                          "Mes banques",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                      ),
                      SizedBox(
                        height: hauteur / 190,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: largeur / 5),
                        child: SizedBox(
                          height: hauteur / 190,
                          width: largeur / 8,
                          child: Container(
                            color: kPrimaryColor1,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: hauteur / 40,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: largeur / 2.5,
                              height: hauteur / 10.5,
                              child: const BanqueCard(
                                logo: 'assets/images/image_two.png',
                                nom: 'BNP Paris Bas',
                              ),
                            ),
                            SizedBox(width: largeur / 50),
                            SizedBox(
                              width: largeur / 2.5,
                              height: hauteur / 10.5,
                              child: const BanqueCard(
                                logo: 'assets/images/image_two.png',
                                nom: 'BNP Paris Bas',
                              ),
                            ),
                            SizedBox(width: largeur / 50),
                            SizedBox(
                              width: largeur / 2.5,
                              height: hauteur / 10.5,
                              child: const BanqueCard(
                                logo: 'assets/images/image_two.png',
                                nom: 'BNP Paris Bas',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
