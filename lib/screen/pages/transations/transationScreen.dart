import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/screen/pages/transations/credit_page.dart';
import 'package:smarth_save/screen/pages/transations/debit_page.dart';

class TransactionScreen extends StatelessWidget {
  final String type;

  TransactionScreen({required this.type});

  @override
  Widget build(BuildContext context) {
    // Déterminer le contenu selon le type
    String title = (type == "credit") ? "Crédit" : "Débit";

    var content = [TransationPageCredi(), TransationPageDebit()];
    double largeur = MediaQuery.of(context).size.width;
    double longeur = MediaQuery.of(context).size.height; // Correction ici

    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Colors.transparent,
      //   automaticallyImplyLeading: false,
      //   title: const Text(
      //     'Statistique',
      //     style: TextStyle(color:Colors.black),
      //   ),
      // leading: IconButton(
      //   icon: const Icon(
      //     Icons.arrow_back_ios,
      //     color: Color.fromARGB(255, 126, 126, 126),
      //   ), // Icône de retour
      //   onPressed: () {
      //     context.go("/transactions");
      //     ; // Revient à l'écran précédent
      //   },
      // ),
      //   actions: [
      //     Builder(
      //       builder: (context) => IconButton(
      //         icon: const Icon(
      //           Icons.menu,
      //           color: Colors.white,
      //         ),
      //         onPressed: () {
      //           Scaffold.of(context).openDrawer();
      //         },
      //       ),
      //     ),
      //   ],
      // ),

      body: Container(
          child: Column(children: [
        Padding(
          // padding: const EdgeInsets.symmetric(horizontal: 10.0),
          padding:  EdgeInsets.only(top:longeur/30.0, left: 10, right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color.fromARGB(255, 126, 126, 126),
                ), // Icône de retour
                onPressed: () {
                  context.go("/transactions");
                  ; // Revient à l'écran précédent
                },
              ),
              const Text(
                'Statistique',
                style: TextStyle(
                  color: kPrimaryColor3,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(
              child: 
              Column(
                children: [
                  Container(
                    width: largeur / 2,
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        context.go('/transaction/credit');
                      },
                      child: Text(
                        "Crédi",
                        style: TextStyle(
                            color:
                                type == "credit" ? Colors.black : Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  type == "credit"
                      ? Container(
                          height: largeur / 120,
                          width: largeur / 2,
                          color: kPrimaryColor1,
                        )
                      : SizedBox(),
                ],
              
                ),
            ),
            SizedBox(
              child: Column(
                children: [
                  Container(
                    width: largeur / 2,
                    alignment: Alignment.center,
                    child: TextButton(
                        onPressed: () {
                          context.go('/transaction/debit');
                        },
                        child: Text("Débit",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: type == "debit"
                                    ? Colors.black
                                    : Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold))),
                  ),
                  type == "debit"
                      ? Container(
                          height: largeur / 120,
                          width: largeur / 2,
                          color: kPrimaryColor1,
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 25),
        Expanded(
          child: SizedBox(
            child: (type == "credit") ? content[0] : content[1],
          ),
        )
      ])),
    );
  }
}
