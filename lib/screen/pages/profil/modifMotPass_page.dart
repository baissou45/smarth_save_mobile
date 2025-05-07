import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/widgets/labeleTextField.dart';
import 'package:smarth_save/widgets/textfield.dart';

class ModifmotpassPage extends StatefulWidget {
  const ModifmotpassPage({super.key});

  @override
  State<ModifmotpassPage> createState() => _ModifmotpassPageState();
}

class _ModifmotpassPageState extends State<ModifmotpassPage> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final NewpassController = TextEditingController();
  final confirmeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double longeur = MediaQuery.of(context).size.height; // Correction ici
    return Scaffold(
      appBar: AppBar(
        title: Text('Changer de mot de passe',
        style: TextStyle(
        fontSize: largeur / 12,
        fontWeight: FontWeight.w900)
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: kPrimaryColor1,
          ), // Icône de retour
          onPressed: () {
            context.go("/"); // Revient à l'écran précédent
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(children: [
            SVTextField(
              controller: passwordController,
              label: 'Ancien mot de passe',
              keyboardType: TextInputType.name,
              isPassword: true,
            ),
            SizedBox(height: 20),
            SVTextField(
              controller: NewpassController,
              label: 'Nouveau mot de passe',
              keyboardType: TextInputType.name,
              isPassword: true,
            ),
            SizedBox(height: 20),
            SVTextField(
              label: "Confirme le mot de passe",
              controller: confirmeController,
              keyboardType: TextInputType.name,
              isPassword: true,
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
                    borderRadius: BorderRadius.circular(10))),
                padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 100)),
              ),
              child: const Text("Modifier",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
