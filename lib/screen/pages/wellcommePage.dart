import 'package:flutter/material.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/widgets/naveBar.dart';
import 'package:smarth_save/widgets/banque_card.dart';

class Wellcommepage extends StatefulWidget {
  const Wellcommepage({super.key});

  @override
  State<Wellcommepage> createState() => _WellcommepageState();
}

class _WellcommepageState extends State<Wellcommepage> {
  var montant ="1095,02";
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
          Builder(
            builder: (context) {
              return InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer(); // Ouvrir le drawer
                },
                child: SizedBox(
                  width: 35,
                  child: CircleAvatar(
                    radius: largeur / 10,
                    backgroundImage: AssetImage('assets/images/image_one.png'),
                  ),
                ),
              );
            },
          ),
          SizedBox(width: largeur / 40.0),
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
                child: 
                Container(
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
      // bottomNavigationBar: ,
    );
  }
}



     // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,

            //     borderRadius: BorderRadius.circular(15), // Coins arrondis
            //     boxShadow: const [
            //       BoxShadow(
            //         color: Colors.black26,
            //         blurRadius: 10,
            //         spreadRadius: 1,
            //         offset: Offset(0, 0), // Ombre vers le bas
            //       ),
            //     ],
            //   ),
            //   padding: EdgeInsets.all(10),
            //   margin: EdgeInsets.only(
            //       top: MediaQuery.of(context).size.height / 90,
            //       left: 10,
            //       right: 10), // Décale vers le haut),
            //   child: Container(
            //     padding: EdgeInsets.all(
            //       MediaQuery.of(context).size.height / 80,
            //     ),
            //     height: MediaQuery.of(context).size.height /
            //         6, // Ajuste la hauteur

            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const SizedBox(
            //           child: Text(
            //             "Mes banque",
            //             style: TextStyle(
            //                 fontSize: 25, fontWeight: FontWeight.w800),
            //           ),
            //         ),
            //         SizedBox(
            //           height: MediaQuery.of(context).size.height / 90,
            //         ),
            //         Container(
            //           margin: EdgeInsets.only(
            //             left: MediaQuery.of(context).size.height / 8,
            //           ),
            //           child: SizedBox(
            //             height: MediaQuery.of(context).size.height / 180,
            //             width: MediaQuery.of(context).size.height / 8,
            //             child: Container(
            //               color: kPrimaryColor1,
            //             ),
            //           ),
            //         ),
            //         SizedBox(
            //           height: MediaQuery.of(context).size.height / 90,
            //         ),
            //         SingleChildScrollView(
            //           scrollDirection: Axis.horizontal,
            //           child: Row(
            //             children: [
            //               SizedBox(
            //                 width: MediaQuery.of(context).size.height /
            //                     4.5, // Espacement entre les cartes
            //                 height: MediaQuery.of(context).size.height / 9,
            //                 child: const BanqueCard(
            //                     logo: 'assets/images/image_two.png',
            //                     nom: 'BNP Paris Bas'),
            //               ),
            //               SizedBox(
            //                 width: MediaQuery.of(context).size.height / 50,
            //               ),
            //               SizedBox(
            //                 width: MediaQuery.of(context).size.height /
            //                     4.5, // Espacement entre les cartes
            //                 height: MediaQuery.of(context).size.height / 9,
            //                 child: const BanqueCard(
            //                     logo: 'assets/images/image_two.png',
            //                     nom: 'BNP Paris Bas'),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
        