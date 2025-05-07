import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/widgets/DropdownButtonFormField%20.dart';
import 'package:smarth_save/widgets/labeleTextField.dart';

class DetailprojetPage extends StatefulWidget {
  const DetailprojetPage({super.key,});

  @override
  State<DetailprojetPage> createState() => _DetailprojetPageState();
}

class _DetailprojetPageState extends State<DetailprojetPage> {
  var nomController = TextEditingController(text: "Nom du projet");
  var categorieController = TextEditingController(text: "categori du projet");
  var periodreController = TextEditingController(text: "periodre");
  var montantController = TextEditingController(text: "montant du projet");
  var _formKey = GlobalKey<FormState>();
  @override
  
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double longeur = MediaQuery.of(context).size.height; // Correction ici
    return Scaffold(
      appBar: AppBar(
          title: const Text('Détail du projet'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: kPrimaryColor1,
            ), // Icône de retour
            onPressed: () {
              context.pop(); // Revient à l'écran précédent
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: longeur / 150,
            ),
            LabeledTextField(
                label: "Nom du projet", hint: "", controller: nomController),
            SizedBox(
              height: longeur / 150,
            ),
            SelectInput(
              initialValue: categorieController.text,
              label: "Catégorie du projet *",
              items: ["Option 1", "Option 2", "Option 3"],
              onChanged: (selectedValue) {
                print("Sélection : $selectedValue");
              },
            ),
            SizedBox(
            height: longeur / 150,
          ),
            SelectInput(
            initialValue: periodreController.text,
              label: "Période du projet  *",
              items: ["Option 1", "Option 2", "Option 3"],
              onChanged: (val) {
                print("Sélection : $val");
              },
            ),
            SizedBox(
              height: longeur / 150,
            ),
            LabeledTextField(
                label: "Montant estimé ",
                hint: "",
                controller: montantController),
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
