import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarth_save/PlaidLogin.dart';
import 'package:smarth_save/controllers/authe_controllers.dart';
import 'package:smarth_save/outils/navigation.dart';
import 'package:smarth_save/screen/Athantification/login_page.dart';
import 'package:smarth_save/widgets/textfield.dart';

// ignore: must_be_immutable
class SigUpPage extends StatelessWidget {
  SigUpPage({super.key});

  var nameController = TextEditingController();
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final largeur = constraints.maxWidth;
            final isSmallScreen = largeur < 380;
            final horizontalMargin = largeur < 600 ? 20.0 : 32.0;

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                horizontalMargin,
                12,
                horizontalMargin,
                20 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFFFFFFFF),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 22 : 28,
                      horizontal: isSmallScreen ? 14 : 18,
                    ),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                'Inscription',
                                style: GoogleFonts.poppins(
                                  fontSize: isSmallScreen ? 36 : 43,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF009292),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SVTextField(
                                controller: nameController,
                                hint: 'Nom complet',
                                keyboardType: TextInputType.name,
                              ),
                              const SizedBox(height: 16),
                              SVTextField(
                                controller: userNameController,
                                hint: 'Nom d\'utilisateur',
                                keyboardType: TextInputType.name,
                              ),
                              const SizedBox(height: 16),
                              SVTextField(
                                controller: emailController,
                                hint: 'Email',
                                keyboardType: TextInputType.name,
                              ),
                              const SizedBox(height: 16),
                              SVTextField(
                                controller: passwordController,
                                hint: 'Mot de passe',
                                keyboardType: TextInputType.name,
                                isPassword: true,
                              ),
                              const SizedBox(height: 16),
                              SVTextField(
                                controller: confirmPasswordController,
                                hint: 'confirmation de mot de passe',
                                keyboardType: TextInputType.name,
                                isPassword: true,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState!.validate()) {
                                      if (passwordController.text ==
                                          confirmPasswordController.text) {
                                        await AutheControllers()
                                            .registerController(
                                          context,
                                          nameController.text,
                                          userNameController.text,
                                          emailController.text,
                                          passwordController.text,
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Les mots de passe ne correspondent pas',
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Veuillez remplir tous les champs',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFF009292),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                  ),
                                  child: const Text(
                                    'Inscrivez-vous',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                'Vous avez deja un compte ?',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                navigationTonextPage(context, LoginPage());
                              },
                              child: Text(
                                'Connectez-vous',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF009292),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1.5,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              'ou',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Divider(
                                thickness: 1.5,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              // action Google login
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              backgroundColor: const Color(0xFFF3F3F3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/facebook.png',
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    'Connectez vous avec facebook',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: const Color(0x9E000000),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              // action Google login
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              backgroundColor: const Color(0xFFF3F3F3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/googleBtn.png',
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    'Connectez vous avec Google',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: const Color(0x9E000000),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
