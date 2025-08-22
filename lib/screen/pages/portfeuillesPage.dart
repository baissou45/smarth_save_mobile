import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/widgets/portefeuilleWidget.dart';

class PortfeuillesPage extends StatefulWidget {
  const PortfeuillesPage({super.key});

  @override
  State<PortfeuillesPage> createState() => _PortfeuillesPageState();
}

class _PortfeuillesPageState extends State<PortfeuillesPage> {
  @override
  Widget build(BuildContext context) {
    double longeur = MediaQuery.of(context).size.height;
    double largeur = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(children: [
        Column(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.teal,
                  ),
                )),
            Expanded(
                flex: 10,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.teal,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                      ),
                    ),
                  ],
                )),
          ],
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Portefeuilles',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Text(
                              '2025',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: longeur / 10),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        child: Text(
                          "Mes portfeuilles",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                      ),
                      SizedBox(
                        height: longeur / 100,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: largeur / 4),
                        child: SizedBox(
                          height: largeur / 190,
                          width: largeur / 7,
                          child: Container(
                            color: kPrimaryColor1,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: largeur / 40,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            SizedBox(width: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PortefeuilleWidget(
                                  title: "Compte courant",
                                  progress: 0,
                                  color: Colors.teal,
                                  amount: "50",
                                ),
                                PortefeuilleWidget(
                                  title: "Compte cheque",
                                  progress: 0,
                                  color: Colors.indigo,
                                  amount: "250",
                                ),
                              ],
                            ),
                            SizedBox(height: longeur / 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PortefeuilleWidget(
                                  title: "Épargne vacances",
                                  progress: 0.85,
                                  color: Colors.purple,
                                  amount: "1300",
                                ),
                                PortefeuilleWidget(
                                  title: "Épargne maison",
                                  progress: 0.45,
                                  color: Colors.orange,
                                  amount: "800",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
