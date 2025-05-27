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
                                    actuelAmount: (index+1) * 200,
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
