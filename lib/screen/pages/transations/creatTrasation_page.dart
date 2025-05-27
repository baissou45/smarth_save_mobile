import 'package:flutter/material.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/widgets/labeleTextField.dart';

import '../../../widgets/DropdownButtonFormField .dart';

class CreateTransactionPage extends StatelessWidget {
  final TextEditingController nomController = TextEditingController();
  final TextEditingController montantController = TextEditingController();
  final TextEditingController periodeController = TextEditingController();
  String categorieController = "";
  @override
  Widget build(BuildContext context) {
    final longeur=MediaQuery.of(context).size.height;
    final largeur=MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Transaction'),
      ),
      body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: longeur / 150,
          ),
          LabeledTextField(
              label: "Nom de la transaction *", hint: "Exemple: Loyer", controller: nomController),
          SizedBox(
            height: longeur / 150,
          ),
          SelectInput(
            label: "Catégorie de la transaction *",
            items: ["Option 1", "Option 2", "Option 3"],
            onChanged: (val) {
              categorieController = val ?? "";
            },
          ),
          SizedBox(
          height: longeur / 150,
        ),
          LabeledTextField(
            isDate: true,
            label: "Période de la transaction *",
            hint: "",
            controller: periodeController,
          ),
          SizedBox(
            height: longeur / 150,
          ),
          LabeledTextField(
              label: "Montant de la transaction",
              hint: "€",
              controller: montantController),
          SizedBox(
            height: longeur / 10,
          ),
          TextButton(
            onPressed: () async {
              // navigationTonextPage(context, const PlaidLogin());
              print("nomController.text: ${nomController.text}");
              print("montantController.text: ${montantController.text}");
              print("categorieController: ${categorieController}");
              print("periodeController: ${periodeController.value}");
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(kPrimaryColor1),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 100)),
            ),
            child: const Text("Enregistrer",
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
