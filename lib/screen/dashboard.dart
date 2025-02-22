import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double longeur = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: longeur / 1.5,
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(largeur / 7),
                bottomRight: Radius.circular(largeur / 7),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: longeur / 5, left: largeur / 20, right: largeur / 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: largeur / 10,
                      backgroundImage:
                          AssetImage('assets/images/image_one.png'),
                    ),
                    SizedBox(width: largeur / 40.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Robert Fox',
                          style: TextStyle(
                              fontSize: largeur / 20, color: Colors.white),
                        ),
                        Text(
                          'michael.mitc@example.com',
                          style: TextStyle(
                              fontSize: largeur / 30, color: Colors.white),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: longeur / 30.0, bottom: longeur / 30.0),
                child: SizedBox(
                  width: largeur / 1.5,
                  child: const Divider(
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                color: Colors.grey,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // BanqueCard(
                      //     logo: 'assets/images/image_two.png',
                      //     nom: 'BNP Paris Bas'),
                      // BanqueCard(
                      //     logo: 'assets/images/image_two.png',
                      //     nom: 'BNP Paris Bas'),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
