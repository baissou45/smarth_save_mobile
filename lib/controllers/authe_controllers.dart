import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/providers/userProvider.dart';
import 'package:smarth_save/utile/widgets/errorWidgets.dart';

class AutheControllers {
  // Appel de la méthode register userProvider
  Future<void> registerController(BuildContext context, String nom,
      String prenom, String email, String password) async {
    final userProvider = context.read<UserProvider>();
    final user =
        UserModel(nom: nom, prenom: prenom, email: email, password: password);
    print("le user est ${user.toMap()}");
    final response = await userProvider.register(user);
    print("la reponse est ${response}");
    if (response) {
      context.go("/login");
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Erreur de connexion')));
      errorToast(context, response);
      debugPrint("Erreur lors de l'inscription : $response");
    }
  }

  // Appel de la méthode login de userProvider
  Future<void> loginController(
      BuildContext context, String email, String password) async {
    final userProvider = context.read<UserProvider>();
    try {
      await userProvider.login(email, password);
      if (userProvider.token != null) {
        context.go("/");
      }
    } catch (e) {
      if (userProvider.message != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${userProvider.message}")));
      }
    }
  }

  // Appel de la méthode de modifier mot de pass de userProvider
  Future<void> modifmotdepasseController(
      BuildContext context, String email) async {
    final userProvider = context.read<UserProvider>();
    await userProvider.modifyPassword(email);
    if (userProvider.error != null) {
      errorToast(context, userProvider.error);
    } else {
      successToast(context, userProvider.message);
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    try {
      await userProvider.loginWithGoogle();
      if (userProvider.token != null) {
        context.go("/");
      }
    } catch (e) {
      if (userProvider.message != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("${userProvider.message}")));
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    final userProvider = context.read<UserProvider>();
    await userProvider.logout();
    if (context.mounted) {
      context.go('/login');
    }
  }
}


// "data":{"id":101,"nom":"jonas","prenom":"jojo","email":"jonas15@gmail.com","role":"mobile"}}