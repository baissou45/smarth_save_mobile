import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/providers/userProvider.dart';
import 'package:smarth_save/screen/Athantification/login_page.dart';
import 'package:smarth_save/screen/dashboard.dart';
import 'package:smarth_save/utile/widgets/errorWidgets.dart';

class AutheControllers {
  final UserProvider userProvider = UserProvider();
  // Appel de la méthode register userProvider
  Future<void> registerController(BuildContext context, String nom,
      String prenom, String email, String password) async {
    final user =
        UserModel(nom: nom, prenom: prenom, email: email, password: password);
    final response = await userProvider.register(user);

    if (response) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur de connexion')));
      errorToast(context, response);
      debugPrint("Erreur lors de l'inscription : $response");
    }
  }

  //Appel de la méthodes login de userProvider
  Future<void> loginController(
      BuildContext context, String email, String password) async {
    try {
      await userProvider.login(email, password);
      if (userProvider.token != null) {
        print("il est connecter ${UserModel.sessionUser?.nom}");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Dashboard()),
          (route) => false,
        );
      }
    } catch (e) {
      if (userProvider.message != null) {

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(userProvider.message)));
      }
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

  Future<void> logout(BuildContext context) async {
    await userProvider.logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }
}


// "data":{"id":101,"nom":"jonas","prenom":"jojo","email":"jonas15@gmail.com","role":"mobile"}}