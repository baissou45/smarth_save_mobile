import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/providers/transactionProvider.dart';
import 'package:smarth_save/providers/userProvider.dart';
import 'package:smarth_save/utile/widgets/errorWidgets.dart';

class TransationControllers {
  // // Appel de la méthode register userProvider
  // Future<void> registerController(BuildContext context, String nom,
  //     String prenom, String email, String password) async {
  //   final user =
  //       UserModel(nom: nom, prenom: prenom, email: email, password: password);
  //   final response = await userProvider.register(user);
  //   print("la reponse est ${response}");
  //   if (response) {
  //     context.go("/login");
  //   } else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(const SnackBar(content: Text('Erreur de connexion')));
  //     errorToast(context, response);
  //     debugPrint("Erreur lors de l'inscription : $response");
  //   }
  // }
  Future <dynamic> getTransaction(BuildContext context) async {
    print("je suis dans le controller");
    final transactionProvider = Provider.of<Transactionprovider>(context, listen: false);
    await transactionProvider.loadTransactions();
    print("controller ${transactionProvider.transactions}");
    return transactionProvider.transactions;
  }
}