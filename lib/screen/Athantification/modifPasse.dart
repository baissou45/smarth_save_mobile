import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarth_save/PlaidLogin.dart';
import 'package:smarth_save/controllers/authe_controllers.dart';
import 'package:smarth_save/outils/navigation.dart';
import 'package:smarth_save/providers/userProvider.dart';
import 'package:smarth_save/screen/Athantification/sig_up.dart';
import 'package:smarth_save/screen/widget/textfield.dart';

// ignore: must_be_immutable
class Modifpasse extends StatelessWidget {
  Modifpasse({super.key});
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserProvider userProvider = UserProvider();

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double longeur = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        ),
        body: Center(
            child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(255, 0, 175, 161),
      ),
      margin: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: longeur / 10.0, horizontal: largeur / 25.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Entrez Votre mail',
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(height: longeur / 15.0),
                    SVTextField(
                      controller: emailController,
                      hint: 'Email',
                      keyboardType: TextInputType.name,
                    ),
                    SizedBox(height: longeur / 15.0),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      TextButton(
                        onPressed: () async {
                        FocusScope.of(context)
                        .unfocus(); // Cacher le clavier
                          if (_formKey.currentState!.validate()) {
                            await AutheControllers().modifmotdepasseController(
                              context,
                              emailController.text,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Veuillez entrer un mail '),
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            const Color.fromARGB(255, 15, 45, 179),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 30),
                          ),
                        ),
                        child: const Text("Envoyer",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            )),
                      ),
                    ])
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    )));
  }
}
