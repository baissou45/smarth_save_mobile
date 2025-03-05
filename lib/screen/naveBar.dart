import 'package:flutter/material.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/providers/userProvider.dart';
import 'package:smarth_save/screen/Athantification/login_page.dart';
import 'dart:math' as math;

class Navebar extends StatefulWidget {
  const Navebar({super.key});

  @override
  State<Navebar> createState() => _NavebarState();
}

class _NavebarState extends State<Navebar> {
  final UserProvider _userProvider = UserProvider();
  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double longeur = MediaQuery.of(context).size.width;
    return Drawer(
        child: ListView(children: [
      Container(
        alignment: Alignment.center,
        height: 150, // Ajustez la hauteur selon vos besoins
        decoration: const BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.only(
            bottomLeft:
                Radius.circular(20), // Ajustez le rayon selon vos besoins
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: largeur / 9,
                backgroundImage: AssetImage('assets/images/image_one.png'),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("${UserModel.sessionUser?.prenom} ${ UserModel.sessionUser?.nom  }",
                    
                    style: TextStyle(
                        fontSize: largeur / 9,
                        color: Colors.white,
                        fontWeight: FontWeight.w900),
                  ),
                  Stack(
                    children: [
                      Text("${UserModel.sessionUser?.email }"
                        ,
                        style: TextStyle(
                          fontSize: largeur / 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Positioned(
                        bottom:
                            0, // Ajustez cette valeur pour contrôler l'espacement
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2, // Épaisseur de la ligne
                          color: Colors.white, // Couleur de la ligne
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 50),
        width: double.infinity,
        alignment: Alignment.center,
        child: Center(
          child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centre les éléments verticalement
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  leading: const Icon(Icons.home_filled,
                  color: Colors.teal,),
                  title:  Text('Accueil'
                  ,style: TextStyle(
                    fontSize:largeur/16
                  ),),
                  onTap: () => {},
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle_outlined,
                  color: Colors.teal,),
                  title:  Text('Mon compte'
                  ,style: TextStyle(
                    fontSize:largeur/16
                  ),),
                  onTap: () => {},
                ),
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet,
                  color: Colors.teal,),
                  title:  Text('Portefeuilles'
                  ,style: TextStyle(
                    fontSize:largeur/16
                  ),),
                  onTap: () => {},
                ),
                ListTile(
                  leading: const Icon(Icons.notes,
                  color: Colors.teal,),
                  title:  Text('Projets'
                  ,style: TextStyle(
                    fontSize:largeur/16
                  ),),
                  onTap: () => {},
                ),
                ListTile(
                  leading: const Icon(Icons.notifications_none,
                  color: Colors.teal,),
                  title:  Text('Notification'
                  ,style: TextStyle(
                    fontSize:largeur/16
                  ),),
                  onTap: () => {},
                ),
                ListTile(
                  leading: const Icon(Icons.settings,
                  color: Colors.teal,),
                  title:  Text('Paramètres'
                  ,style: TextStyle(
                    fontSize:largeur/16
                  ),),
                  onTap: () => {},
                ),
                ListTile(
                  leading: const Icon(Icons.account_box,
                  color: Colors.teal,),
                  title:  Text('Nous contacter'
                  ,style: TextStyle(
                    fontSize:largeur/16
                  ),),
                  onTap: () => {},
                ),
                SizedBox(height: largeur / 7),
              ]),
        ),
      ),
      Container(
        padding: EdgeInsets.all(6),
        color: Colors.teal,
        width: largeur / 2,
        height: largeur / 6,
        alignment: Alignment.center,
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: largeur / 9, // Largeur totale du cercle
                          height: largeur / 9, // Hauteur totale du cercle
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // Forme circulaire
                            border: Border.all(
                              color: Colors.white, // Couleur de la bordure
                              width: 2.0, // Épaisseur de la bordure
                            ),
                          ),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math
                                .pi), // Fait pivoter l'icône de 180 degrés autour de l'axe Y
                            child: const Icon(
                              Icons.exit_to_app_sharp,
                              color: Colors.white, // Couleur de l'icône
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Handle button press
                            await _userProvider.logout();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (route) => false);
                          },
                          child: const Text(
                            'Deconnexion',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                ),
                Container(
                  color: Colors.white,
                  child: SizedBox(
                    width: longeur / 150,
                    height: largeur,
                  ),
                ),
                SizedBox(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: largeur / 9, // Largeur totale du cercle
                          height: largeur / 9, // Hauteur totale du cercle
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // Forme circulaire
                            border: Border.all(
                              color: Colors.white, // Couleur de la bordure
                              width: 2.0, // Épaisseur de la bordure
                            ),
                          ),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math
                                .pi), // Fait pivoter l'icône de 180 degrés autour de l'axe Y
                            child: const Icon(
                              Icons.chat_bubble,
                              color: Colors.white, // Couleur de l'icône
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Handle button press
                          },
                          child: const Text(
                            'Chat Bot',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                ),
              
                ],
            )),
      ),
    ]));
  }
}
