import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarth_save/outils/navigation.dart';
import 'package:smarth_save/screen/Athantification/login_page.dart';
import 'package:smarth_save/screen/widget/textfield.dart';

class SigUpPage extends StatelessWidget {
  SigUpPage({super.key});

  var nameController = TextEditingController();
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: const Color.fromARGB(255, 0, 175, 161),
      ),
      margin: const EdgeInsets.only(top: 70, left: 10, right: 10, bottom: 40),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Form(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Inscription',
                        style: GoogleFonts.poppins(
                            fontSize: 43,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SVTextField(
                      controller: nameController,
                      hint: 'Nom complet',
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 20),
                    SVTextField(
                      controller: userNameController,
                      hint: 'Nom d\'utilisateur',
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 20),
                    SVTextField(
                      controller: emailController,
                      hint: 'Email',
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 20),
                    SVTextField(
                      controller: passwordController,
                      hint: 'Mot de passe',
                      keyboardType: TextInputType.name,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    SVTextField(
                      controller: confirmPasswordController,
                      hint: 'confirmation de mot de passe',
                      keyboardType: TextInputType.name,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      TextButton(
                        onPressed: () {
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                              const Color.fromARGB(255, 15, 45, 179)),
                          shape: WidgetStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                          padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(horizontal: 30)),
                        ),
                        child: const Text("Inscrivez-vous",
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Vous avez deja un compte ?',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11,
                  )),
              TextButton(
                onPressed: () {
                  navigationTonextPage(context, LoginPage());
                },
                child: Text('Connectez-vous',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                  width: 100,
                  height: 3,
                  child: Container(
                    color: Colors.white,
                  )),
              const SizedBox(width: 20),
              const SizedBox(
                child: Text("ou",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
              const SizedBox(width: 20),
              SizedBox(
                  width: 100,
                  height: 3,
                  child: Container(
                    color: Colors.white,
                  )),
            ]),
            const SizedBox(height: 15),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 55,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)),
                child: TextButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  child: Image.asset("assets/images/googleBtn.png",
                      width: 40, height: 40),
                ),
              ),
            ]),
            const SizedBox(height: 15),
          ],
        ),
      ),
    )));
  }
}
