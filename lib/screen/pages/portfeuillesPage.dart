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
    final double longeur = MediaQuery.of(context).size.height;
    final double largeur = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/creatProjet');
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  color: kPrimaryColor1,
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  color: Colors.grey[100],
                ),
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre et année
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
                        SizedBox(
                          height: largeur / 40,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              const SizedBox(width: 20),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  PortefeuilleWidget(
                                    title: "Restauration",
                                    progress: 0.5,
                                    color: Colors.teal,
                                    amount: 100,
                                    actuelAmount: 30,
                                  ),
                                  PortefeuilleWidget(
                                    title: "Transport",
                                    progress: 0.25,
                                    color: Colors.teal,
                                    amount: 100,
                                    actuelAmount: 20,
                                  ),
                                ],
                              ),
                              SizedBox(height: longeur / 40),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  PortefeuilleWidget(
                                    title: "Alimentation",
                                    progress: 0.65,
                                    color: Colors.orange,
                                    amount: 300,
                                    actuelAmount: 150,
                                  ),
                                  PortefeuilleWidget(
                                    title: "Habitation",
                                    progress: 0.45,
                                    color: Colors.teal,
                                    amount: 800,
                                    actuelAmount: 200,
                                  ),
                                ],
                              ),
                              SizedBox(height: longeur / 40),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  PortefeuilleWidget(
                                    title: "Sante",
                                    progress: 0.10,
                                    color: Colors.teal,
                                    amount: 200,
                                    actuelAmount: 30,
                                  ),
                                  PortefeuilleWidget(
                                    title: "Loisirs",
                                    progress: 0.85,
                                    color: Colors.red,
                                    amount: 400,
                                    actuelAmount: 50,
                                  ),
                                ],
                              ),
                              SizedBox(height: longeur / 40),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  PortefeuilleWidget(
                                    title: "Education",
                                    progress: 0.8,
                                    color: Colors.red,
                                    amount: 200,
                                    actuelAmount: 100,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: longeur / 25),

                  // Conteneur blanc avec contenu
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      margin: EdgeInsets.only(
                          top: longeur / 25, left: 10, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Mes portefeuilles",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w800),
                          ),
                          SizedBox(height: largeur / 40),
                          Container(
                            margin: EdgeInsets.only(left: largeur / 4),
                            height: largeur / 190,
                            width: largeur / 7,
                            color: kPrimaryColor1,
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 éléments par ligne
                                crossAxisSpacing:
                                    30, // espacement horizontal entre les éléments
                                // mainAxisSpacing: 2,    // espacement vertical entre les éléments
                                childAspectRatio: 4.5 /
                                    2, // ratio largeur/hauteur de chaque cellule, adapte selon ton widget
                              ),
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  child: PortefeuilleWidget(
                                    title: "Épargne $index",
                                    amount: 1000,
                                    actuelAmount: (index + 1) * 200,
                                    progress: 58,
                                    color: Colors.teal,
                                  ),
                                );
                              },
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
        ],
      ),
    );
  }
}
