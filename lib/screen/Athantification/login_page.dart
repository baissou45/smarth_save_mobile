import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarth_save/controllers/authe_controllers.dart';
import 'package:smarth_save/outils/navigation.dart';
import 'package:smarth_save/providers/userProvider.dart';
import 'package:smarth_save/screen/Athantification/modifPasse.dart';
import 'package:smarth_save/widgets/textfield.dart';
import 'package:smarth_save/screen/Athantification/sig_up.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserProvider userProvider = UserProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final largeur = constraints.maxWidth;
            final longeur = constraints.maxHeight;
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
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(15),
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
                          vertical: isSmallScreen ? 18 : 24,
                          horizontal: isSmallScreen ? 14 : 18,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                'Connexion',
                                style: GoogleFonts.poppins(
                                  fontSize: isSmallScreen ? 34 : 40,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF009292),
                                ),
                              ),
                              SizedBox(height: longeur * 0.03),
                              Text(
                                'Pour se connecter sur cette application, entrer son nom d’utilisateur et son mot de passe',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: isSmallScreen ? 11 : 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: longeur * 0.025),
                              SVTextField(
                                controller: emailController,
                                hint: 'Nom d\'utilisateur',
                                keyboardType: TextInputType.name,
                              ),
                              const SizedBox(height: 16),
                              SVTextField(
                                controller: passwordController,
                                hint: 'Mot de passe',
                                keyboardType: TextInputType.name,
                                isPassword: true,
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: () async {
                                  navigationTonextPage(context, Modifpasse());
                                },
                                child: const Text(
                                  'Mot de passe oublié ?',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF009292),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () async {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState!.validate()) {
                                      await AutheControllers().loginController(
                                        context,
                                        emailController.text,
                                        passwordController.text,
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
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
                                    'Connexion',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              const Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      thickness: 1.5,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      'Vous n\'avez pas de compte ?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Divider(
                                      thickness: 1.5,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                      onPressed: () {
                                       navigationTonextPage(context, SigUpPage());
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
                                          Text(
                                            'Créer un compte',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: const Color(0xFF009292),
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
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'En cliquant sur «\u00a0Continuer\u00a0», je confirme avoir lu et accepté les conditions générales et la politique de confidentialité.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
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
