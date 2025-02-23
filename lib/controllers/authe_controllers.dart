import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/providers/userProvider.dart';
import 'package:smarth_save/utile/widgets/errorWidgets.dart';

class AutheControllers {
  // Appel de la méthode register userProvider
  Future<void> registerController(BuildContext context, String nom,
      String prenom, String email, String password) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await userProvider.register(nom, prenom, email, password);
    if (response == true) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur de connexion')));
      errorToast(context, response);
      debugPrint("Erreur lors de l'inscription : $response");
    }
  }

  //Appel de la méthodes login de userProvider
  Future<void> loginController(
      BuildContext context, String email, String password) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await userProvider.login(email, password);
    if (response == true) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur de connexion'))
      errorToast(context, response);
      debugPrint("Erreur lors de la connexion : $response");
    }
  }

  // Appel de la méthode de modifier mot de pass de userProvider
  Future<void> modifmotdepasseController(
      BuildContext context, String email) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await userProvider.modifmotdepasse(email);
    if (response == true) {
      errorToast(context, response);
    } else {
      errorToast(context, response);
    }
  }
}
