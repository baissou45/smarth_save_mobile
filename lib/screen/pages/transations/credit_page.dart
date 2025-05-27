import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smarth_save/controllers/transation_controllers.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/transation_model.dart';
import 'package:smarth_save/providers/transactionProvider.dart';
import 'package:smarth_save/services/api_transaction_service.dart';
import 'package:smarth_save/widgets/naveBar.dart';
import 'package:smarth_save/widgets/textfield.dart';
import 'package:smarth_save/widgets/transaction_card.dart';
import 'package:intl/intl.dart';

class TransationPageCredi extends StatefulWidget {
  const TransationPageCredi({super.key});

  @override
  State<TransationPageCredi> createState() => _TransationPageCrediState();
}

class _TransationPageCrediState extends State<TransationPageCredi> {
  final ApiTransactionService apiTransactionService = ApiTransactionService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searcheController = TextEditingController();
  TransationControllers transationControllers = TransationControllers();
  Transactionprovider transactionprovider = Transactionprovider();
  List<TransactionModel> transactions = []; // Liste des transactions
  List<TransactionModel> allTransactions = []; // Liste des transactions
  List<TransactionModel> filteredTransactions = []; // Liste filtrée

  String selectedFilter = ""; // 📌 Par défaut, filtre par mois
  @override
  void initState() {
    // TODO: implement initState
    _loadTransactions();
    super.initState();
  }

  // Fonction pour appeler le controller et récupérer les transactions
  Future<void> _loadTransactions() async {
    print("avent");
    final transactionsFromController =
        await transationControllers.getTransaction(context);
    setState(() {
      transactions = transactionsFromController;
      allTransactions = transactionsFromController;
    });
  }

  // 📌 Fonction pour filtrer les transactions en fonction de la période sélectionnée
  void _applyFilter(String filterType) {
    setState(() {
      // Réinitialiser la liste des transactions à toutes les transactions disponibles
      transactions =
          allTransactions; // assuming `allTransactions` contains all transactions without any filter.

      DateTime now = DateTime.now();

      transactions = transactions.where((transaction) {
        var dateValidation = transaction.toJson()["dateValidation"];

        if (dateValidation is String) {
          // Convertir la date String en DateTime
          dateValidation = DateTime.parse(dateValidation);
        }

        if (dateValidation is! DateTime) return false; // Éviter les erreurs

        // Filtrage en fonction de la période
        if (filterType == "Jour") {
          return dateValidation.year == now.year &&
              dateValidation.month == now.month &&
              dateValidation.day == now.day;
        } else if (filterType == "Semaine") {
          DateTime weekAgo = now.subtract(Duration(days: 7));
          return dateValidation.isAfter(weekAgo) &&
              dateValidation.isBefore(now);
        } else if (filterType == "Mois") {
          return dateValidation.year == now.year &&
              dateValidation.month == now.month;
        } else if (filterType == "Année") {
          return dateValidation.year == now.year;
        }

        return false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double longeur = MediaQuery.of(context).size.height; // Correction ici
    return Scaffold(
      drawer: Navebar(),
      body: Column(
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: longeur / 2.4,
              minHeight: longeur / 2.5,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: longeur / 3,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: const Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                ),
                Positioned(
                  top: longeur/30,
                  left: largeur / 2.9,
                  child: CircleAvatar(
                    radius: largeur / 4,
                    backgroundColor: kSecondColor,
                  ),
                ),
                Positioned(
                  top: longeur/ 150,
                  child: CircleAvatar(
                    radius: largeur / 4,
                    backgroundColor: kPrimaryColor1,
                  ),
                ),
                Positioned(
                  top: longeur/45,
                  right: largeur / 3,
                  child: CircleAvatar(
                    radius: largeur / 4,
                    backgroundColor: kPrimaryColor1,
                  ),
                ),
                Positioned(
                  top:longeur/19,
                  right: largeur / 5.5,
                  child: CircleAvatar(
                    radius: largeur / 3.7,
                    backgroundColor: const Color(0xFF737986),
                  ),
                ),
                Positioned(
                  top:longeur/15,
                  right: largeur / 3.5,
                  child: CircleAvatar(
                    radius: largeur / 3.8,
                    backgroundColor: kPrimaryColor1,
                  ),
                ),
                Positioned(
                  top: 20,
                  child: CircleAvatar(
                    radius: largeur / 3.6,
                    backgroundColor: primaryButtonTextColor,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total entrées',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: kPrimaryColor1),
                        ),
                        Text(
                          '2 834,00 €',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: kPrimaryColor1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(8, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Entrées",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        var transaction = transactions[index];
                        var transactionJson = transaction.toJson();

                        if (transactionJson.containsKey("categorie") &&
                            transactionJson["categorie"]
                                .containsKey("libelle")) {
                          if (transactionJson["categorie"]["libelle"].trim() ==
                              "Crédit") {
                            return SizedBox(
                              child: TransactionCard(
                                logo: 'assets/images/image_two.png',
                                label: transactionJson["institution"]
                                    ["libelle"],
                                date: transactionJson["dateValidation"] != null
                                    ? DateFormat('dd/MM/yyyy').format(
                                        DateTime.parse(
                                            transactionJson["dateValidation"]))
                                    : "Date inconnue",
                                montant: transactionJson["montant"],
                                type: transactionJson["categorie"]["libelle"],
                              ),
                            );
                          }
                        }

                        // Retourne un widget vide si la transaction ne correspond pas
                        return SizedBox.shrink();
                      },
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

  Widget _buildIconText(Widget icon, String label, VoidCallback action) {
    return Column(
      children: [
        Container(
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
          child: CircleAvatar(
            backgroundColor: kPrimaryColor1,
            radius: 30, // Ajuste la taille
            child: IconButton(
                onPressed: () {
                  action();
                },
                icon: icon), // Utilisation directe du widget SVG ou icône
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String label) {
    return TextButton(
      onPressed: () {
        setState(() {
          selectedFilter = label; // 📌 Mettre à jour le filtre sélectionné
          print(selectedFilter);
          _applyFilter(selectedFilter); // 📌 Appliquer le filtre
        });
      },
      style: TextButton.styleFrom(
        backgroundColor:
            selectedFilter == label ? kPrimaryColor1 : Colors.white,
        foregroundColor: selectedFilter == label ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }
}

Widget _buildLayout(double left, double top, String label) {
  return Positioned(
    left: left,
    top: top,
    child: Container(
      width: 174,
      height: 169,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    ),
  );
}
