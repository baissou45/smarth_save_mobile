import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // <--- important
import 'package:provider/provider.dart'; // <--- important
import 'package:smarth_save/controllers/transation_controllers.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/transation_model.dart';
import 'package:smarth_save/providers/transactionProvider.dart';
import 'package:smarth_save/widgets/naveBar.dart';
import 'package:smarth_save/widgets/textfield.dart';
import 'package:smarth_save/widgets/transaction_card.dart';
import 'package:intl/intl.dart';

class TransationPage extends StatefulWidget {
  const TransationPage({super.key});

  @override
  State<TransationPage> createState() => _TransationPageState();
}

class _TransationPageState extends State<TransationPage> {
  final TransationControllers transationControllers = TransationControllers();
  final TextEditingController searcheController = TextEditingController();

  List<TransactionModel> allTransactions = [];
  List<TransactionModel> filteredTransactions = [];

  String selectedFilter = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTransactions();
    });
  }

  Future<void> _loadTransactions() async {
    final transactionProvider = context.read<Transactionprovider>();
    transactionProvider.setLoading(true);

    final transactionsFromController =
        await transationControllers.getTransaction(context);

    // Update provider et listes locales
    if (!mounted) return;
    setState(() {
      allTransactions = transactionsFromController;
      filteredTransactions = transactionsFromController;
    });

    transactionProvider.setLoading(false);
  }

  void _applyFilter(String filterType) {
    setState(() {
      selectedFilter = filterType;

      DateTime now = DateTime.now();

      filteredTransactions = allTransactions.where((transaction) {
        var dateValidation = transaction.toJson()["dateValidation"];
      
        if (dateValidation is String) {
          dateValidation = DateTime.parse(dateValidation);
        }

        if (dateValidation == null) return false;

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
    final transactionProvider = context.watch<Transactionprovider>();
    final largeur = MediaQuery.of(context).size.width;
    final longeur = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor1,
        automaticallyImplyLeading: false,
        title: const Text(
          'Historique des transactions',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => context.go("/accueil"),
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/notification'),
            icon: Container(
              width: 45,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(4, 4),
                  ),
                ],
              ),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Icon(Icons.notifications_active_outlined),
              ),
            ),
          ),
        ],
      ),
      drawer: Navebar(),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                height: longeur / 4,
                decoration: const BoxDecoration(
                  color: kPrimaryColor1,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: largeur / 1.2,
                        child: SVTextField(
                          prefix: const Icon(Icons.search),
                          controller: searcheController,
                          hint: 'Search',
                          keyboardType: TextInputType.name,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildIconText(
                            SvgPicture.asset("assets/svg/credit.svg"),
                            'Crédit',
                            () => context.push('/transaction/credit'),
                          ),
                          _buildIconText(
                            SvgPicture.asset("assets/svg/debit.svg"),
                            'Débit',
                            () => context.push('/transaction/debit'),
                          ),
                          _buildIconText(
                            SvgPicture.asset("assets/svg/ajout.svg"),
                            'Ajouter',
                            () => context.push("/creatTransaction"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin:
                    EdgeInsets.only(top: longeur / 3.4, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFilterButton('Jour'),
                        _buildFilterButton('Semaine'),
                        _buildFilterButton('Mois'),
                        _buildFilterButton('Année'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
              margin: EdgeInsets.only(top: longeur / 25, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Transactions",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    margin: EdgeInsets.only(left: largeur / 5),
                    width: largeur / 8,
                    height: 4,
                    color: kPrimaryColor1,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: transactionProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : filteredTransactions.isNotEmpty
                            ? ListView.builder(
                                itemCount: filteredTransactions.length,
                                itemBuilder: (context, index) {
                                  var transaction = filteredTransactions[index];
                                  var transactionJson = transaction.toJson();
                                  return TransactionCard(
                                    logo: 'assets/images/image_two.png',
                                    label: transactionJson["institution"]
                                            ["libelle"] ??
                                        "Inconnu",
                                    date: transactionJson["dateValidation"] !=
                                            null
                                        ? DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(transactionJson[
                                                "dateValidation"]))
                                        : "Date inconnue",
                                    montant: transactionJson["montant"] ?? 0,
                                    type: transactionJson["type"] ?? "",
                                  );
                                },
                              )
                            : const Center(
                                child: Text("Aucune transaction trouvée"),
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
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: CircleAvatar(
            backgroundColor: kPrimaryColor1,
            radius: 30,
            child: IconButton(
              onPressed: action,
              icon: icon,
            ),
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
      onPressed: () => _applyFilter(label),
      style: TextButton.styleFrom(
        backgroundColor:
            selectedFilter == label ? kPrimaryColor1 : Colors.white,
        foregroundColor: selectedFilter == label ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }
}
