import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smarth_save/controllers/transation_controllers.dart';
import 'package:smarth_save/models/transation_model.dart';
import 'package:smarth_save/widgets/naveBar.dart';
import 'package:smarth_save/widgets/transaction_card.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';

class TransactionCache {
  static List<TransactionModel> creditTransactions = [];
  static bool hasLoadedCredit = false;

  static List<TransactionModel> debitTransactions = [];
  static bool hasLoadedDebit = false;
}

class TransationPageDebit extends StatefulWidget {
  const TransationPageDebit({super.key});

  @override
  State<TransationPageDebit> createState() => _TransationPageDebitState();
}

class _TransationPageDebitState extends State<TransationPageDebit> {
  final TransationControllers transationControllers = TransationControllers();

  List<TransactionModel> transactions = [];
  List<TransactionModel> allTransactions = [];
  String selectedFilter = "";

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    if (TransactionCache.hasLoadedDebit) {
      setState(() {
        transactions = TransactionCache.debitTransactions;
        allTransactions = TransactionCache.debitTransactions;
      });
      return;
    }

    final transactionsFromController =
        await transationControllers.getTransaction(context);

    final debitOnly = transactionsFromController
        .where((t) => t.type?.trim() == "debit")
        .toList();

    setState(() {
      transactions = debitOnly;
      allTransactions = debitOnly;
      TransactionCache.debitTransactions = debitOnly;
      TransactionCache.hasLoadedDebit = true;
    });
  }

  void _applyFilter(String filterType) {
    setState(() {
      transactions = allTransactions;

      DateTime now = DateTime.now();

      transactions = transactions.where((transaction) {
        var dateValidation = transaction.toJson()["dateValidation"];

        if (dateValidation is String) {
          dateValidation = DateTime.parse(dateValidation);
        }

        if (dateValidation is! DateTime) return false;

        if (filterType == "Jour") {
          return dateValidation.year == now.year &&
              dateValidation.month == now.month &&
              dateValidation.day == now.day;
        } else if (filterType == "Semaine") {
          DateTime weekAgo = now.subtract(const Duration(days: 7));
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
    double longeur = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: const Navebar(),
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
                ),
                Positioned(
                  top: longeur / 30,
                  left: largeur / 2.9,
                  child: CircleAvatar(
                    radius: largeur / 4,
                    backgroundColor: kSecondColor,
                  ),
                ),
                Positioned(
                  top: longeur / 150,
                  child: CircleAvatar(
                    radius: largeur / 4,
                    backgroundColor: errorToastColor,
                  ),
                ),
                Positioned(
                  top: longeur / 45,
                  right: largeur / 3,
                  child: CircleAvatar(
                    radius: largeur / 4,
                    backgroundColor: errorToastColor,
                  ),
                ),
                Positioned(
                  top: longeur / 19,
                  right: largeur / 5.5,
                  child: CircleAvatar(
                    radius: largeur / 3.7,
                    backgroundColor: const Color.fromARGB(255, 177, 181, 189),
                  ),
                ),
                Positioned(
                  top: longeur / 15,
                  right: largeur / 3.5,
                  child: CircleAvatar(
                    radius: largeur / 3.8,
                    backgroundColor: const Color.fromARGB(255, 177, 181, 189),
                  ),
                ),
                Positioned(
                  top: longeur / 30,
                  right: largeur / 4.5,
                  child: CircleAvatar(
                    radius: largeur / 3.6,
                    backgroundColor: primaryButtonTextColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total sorties',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: errorToastColor),
                        ),
                        Text(
                          '${transactions.fold(0, (sum, t) => sum + (double.tryParse(t.montant ?? "0")?.toInt() ?? 0))} €',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: errorToastColor),
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
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sorties",
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
                          if (transactionJson["type"].trim() == "debit") {
                            return TransactionCard(
                              logo: 'assets/images/image_two.png',
                              label: transactionJson["institution"]["libelle"],
                              date: transactionJson["dateValidation"] != null
                                  ? DateFormat('dd/MM/yyyy').format(
                                      DateTime.parse(
                                          transactionJson["dateValidation"]))
                                  : "Date inconnue",
                              montant: transactionJson["montant"],
                              type: transactionJson["type"],
                            );
                          }
                        }
                        return const SizedBox.shrink();
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
}
