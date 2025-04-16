import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarth_save/controllers/authe_controllers.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/widgets/labeleTextField.dart';
import 'package:smarth_save/widgets/textfield.dart';

class DetailCompte extends StatefulWidget {
  const DetailCompte({super.key});

  @override
  State<DetailCompte> createState() => _DetailCompteState();
}

class _DetailCompteState extends State<DetailCompte> {
  final _formKey = GlobalKey<FormState>();
  var nomController = TextEditingController(
      text: '${UserModel.sessionUser?.prenom} ${UserModel.sessionUser?.nom}',);
  var userController =
      TextEditingController(text: '${UserModel.sessionUser?.nom}');
  var emailController =
      TextEditingController(text: '${UserModel.sessionUser?.email}');
  var phoneController =
      TextEditingController(text: '${UserModel.sessionUser?.email}');
  var passController =
      TextEditingController(text: '${UserModel.sessionUser?.password}');
  @override
  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double longeur = MediaQuery.of(context).size.height; // Correction ici
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le profil'),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: kPrimaryColor1,
          ), // Icône de retour
          onPressed: () {
            context.go('/'); // Revient à l'écran précédent
          },
        ),
      ),
      body: 
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(children: [
            LabeledTextField(
                label: 'Nom complet',
                hint: '',
                defaultValue: 'Robert Fox',
                controller: nomController,),
            SizedBox(
              height: longeur / 150,
            ),
            LabeledTextField(
                label: "Nom d'utilisateur",
                hint: '',
                controller: userController,),
            SizedBox(
              height: longeur / 150,
            ),
            LabeledTextField(
                label: 'Email', hint: '', controller: emailController,),
            SizedBox(
              height: longeur / 150,
            ),
            LabeledTextField(
                label: 'Mot de passe', hint: '', controller: passController,),
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  // navigationTonextPage(context, const PlaidLogin());
                },
                child: const Text('Modifier le mot de passe',
                    style: TextStyle(
                      fontSize: 15,
                      color: kPrimaryColor1,
                    ),),
              ),
            ),
            SizedBox(
              height: longeur / 10,
            ),
            TextButton(
              onPressed: () async {
                // navigationTonextPage(context, const PlaidLogin());
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kPrimaryColor1),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),),),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 100),),
              ),
              child: const Text('Enregistrer',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),),
            ),
          ],),
        ),
      ),
    );
  }
}
