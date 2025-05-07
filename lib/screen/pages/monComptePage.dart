import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarth_save/models/user_model.dart';

class MonComptePage extends StatefulWidget {
  const MonComptePage({super.key});

  @override
  State<MonComptePage> createState() => _MonComptePageState();
}

class _MonComptePageState extends State<MonComptePage> {
  @override
  Widget build(BuildContext context) {
    double longeur = MediaQuery.of(context).size.height;
    double largeur = MediaQuery.of(context).size.width;

    rounded_icon(IconData icon, Color bg_color, Color icon_color,
        {double size = 9, double icon_size = 25}) {
      return Container(
        width: largeur / size,
        height: largeur / size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bg_color,
        ),
        child: Icon(icon, color: icon_color, size: icon_size),
      );
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: longeur / 30.0),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: longeur / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Profil',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: largeur / 12,
                            fontWeight: FontWeight.w900)),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: largeur / 5,
                          backgroundImage:
                              const AssetImage('assets/images/avatar.webp'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: largeur / 50,
                          child: rounded_icon(
                              Icons.edit, Colors.teal, Colors.white),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "${UserModel.sessionUser?.prenom ?? ""} ${UserModel.sessionUser?.nom ?? ""}",
                          style: TextStyle(
                              fontSize: largeur / 20,
                              fontWeight: FontWeight.w900),
                        ),
                        Text(
                          UserModel.sessionUser?.email ?? '',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontStyle: FontStyle.italic,
                            fontSize: largeur / 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: longeur / 2.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        {
                          'icon': Icons.person,
                          'title': 'Modifier le profil',
                        },
                        {
                          'icon': Icons.lock,
                          'title': 'Modifier le mot de passe',
                        },
                        {
                          'icon': CupertinoIcons.chat_bubble_2_fill,
                          'title': 'Messagerie',
                        },
                      ]
                          .map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: ListTile(
                                onTap: () {
                                  if (item['title'] == 'Modifier le profil') {
                                    context.go('/modifProfile');
                                  } else if (item['title'] ==
                                      'Modifier le mot de passe') {
                                    context.go('/modifMotPass');
                                  } else if (item['title'] == 'Messagerie') {
                                    context.go('');
                                  }
                                },
                                leading: rounded_icon(
                                  item['icon'] as IconData,
                                  Colors.teal,
                                  Colors.white,
                                  size: 11,
                                  icon_size: 16,
                                ),
                                title: Text(
                                  item['title'] as String,
                                  style: TextStyle(
                                    fontSize: largeur / 25,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios_rounded),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                      UserModel.sessionUser?.logout();
                        context.go('/login');
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      label: Text(
                        'Se deconnecter',
                        style: TextStyle(
                          fontSize: largeur / 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
