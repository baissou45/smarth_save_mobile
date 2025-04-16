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

class TransationPage extends StatefulWidget {
  const TransationPage({super.key});

  @override
  State<TransationPage> createState() => _TransationPageState();
}

class _TransationPageState extends State<TransationPage> {
  final ApiTransactionService apiTransactionService = ApiTransactionService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searcheController = TextEditingController();
  TransationControllers transationControllers = TransationControllers();
  Transactionprovider transactionprovider = Transactionprovider();
  List<TransactionModel> transactions = []; // Liste des transactions
  List<TransactionModel> allTransactions = []; // Liste des transactions
  List<TransactionModel> filteredTransactions = []; // Liste filtrée

  String selectedFilter = ''; // 📌 Par défaut, filtre par mois
  @override
  void initState() {
    // TODO: implement initState
    _loadTransactions();
    super.initState();
  }

  // Fonction pour appeler le controller et récupérer les transactions
  Future<void> _loadTransactions() async {
    print('avent');
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
        var dateValidation = transaction.toJson()['dateValidation'];

        if (dateValidation is String) {
          // Convertir la date String en DateTime
          dateValidation = DateTime.parse(dateValidation);
        }

        if (dateValidation is! DateTime) return false; // Éviter les erreurs

        // Filtrage en fonction de la période
        if (filterType == 'Jour') {
          return dateValidation.year == now.year &&
              dateValidation.month == now.month &&
              dateValidation.day == now.day;
        } else if (filterType == 'Semaine') {
          DateTime weekAgo = now.subtract(const Duration(days: 7));
          return dateValidation.isAfter(weekAgo) &&
              dateValidation.isBefore(now);
        } else if (filterType == 'Mois') {
          return dateValidation.year == now.year &&
              dateValidation.month == now.month;
        } else if (filterType == 'Année') {
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
    print('la taille ${transactions.length}');
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
          ), // Icône de retour
          onPressed: () {
            context.go('/accueil'); // Revient à l'écran précédent
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_outlined),
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.white),
              shape: WidgetStateProperty.all(const CircleBorder()),
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
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
                height: longeur / 3,
                decoration: const BoxDecoration(
                  color: kPrimaryColor1,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
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
                              SvgPicture.asset(
                                'assets/svg/credit.svg',
                              ),
                              'Crédit',
                              () => context.push('/transaction/credit'),),
                          _buildIconText(
                              SvgPicture.asset(
                                'assets/svg/debit.svg',
                              ),
                              'Débit',
                              () => context.push('/transaction/debit'),),
                          _buildIconText(
                              SvgPicture.asset(
                                'assets/svg/ajout.svg',
                              ),
                              'Ajouter',
                              () => context.push('/creatProjet'),),
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
                    'Transactions',
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
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        var transaction = transactions[index];
                        var transactionJson = transaction.toJson();
                        return SizedBox(
                          child: TransactionCard(
                            logo: 'assets/images/image_two.png',
                            label: transactionJson['institution']['libelle'],
                            date: transactionJson['dateValidation'] != null
                                ? DateFormat('dd/MM/yyyy').format(
                                    DateTime.parse(
                                        transactionJson['dateValidation'],),)
                                : 'Date inconnue',
                            montant: transactionJson['montant'],
                            type: transactionJson['categorie']['libelle'],
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
                icon: icon,), // Utilisation directe du widget SVG ou icône
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
  // Widget _buildFilterButton(String label) {
  //   return TextButton(
  //     onPressed: () {},
  //     child: Text(label),
  //   );
  // }
}
