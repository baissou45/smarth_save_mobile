import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarth_save/controllers/authe_controllers.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/outils/navigation.dart';
import 'package:smarth_save/screen/Athantification/login_page.dart';
import 'package:smarth_save/widgets/textfield.dart';

class SigUpPage extends StatefulWidget {
  const SigUpPage({super.key});

  @override
  State<SigUpPage> createState() => _SigUpPageState();
}

class _SigUpPageState extends State<SigUpPage> {
  final _formKey = GlobalKey<FormState>();
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: kDanger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
      _showError('Les mots de passe ne correspondent pas');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AutheControllers().registerController(
        context,
        '${nomController.text} ${prenomController.text}',
        emailController.text,
        passwordController.text,
        passwordController.text,
      );
    } catch (e) {
      _showError('Erreur d\'inscription: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: kBgPage),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header gradient
              Container(
                height: 180,
                decoration: const BoxDecoration(
                  gradient: kHeaderGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'S\'inscrire',
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Créer votre compte SmartSave',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: kTealLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Card form
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: kBgCard,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: kNavyDark.withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nom
                        SVTextField(
                          controller: nomController,
                          label: 'Nom',
                          hint: 'Votre nom',
                          keyboardType: TextInputType.name,
                          prefix: const Icon(Icons.person, color: kTeal),
                        ),
                        const SizedBox(height: 16),

                        // Prenom
                        SVTextField(
                          controller: prenomController,
                          label: 'Prénom',
                          hint: 'Votre prénom',
                          keyboardType: TextInputType.name,
                          prefix: const Icon(Icons.person, color: kTeal),
                        ),
                        const SizedBox(height: 16),

                        // Email
                        SVTextField(
                          controller: emailController,
                          label: 'Email',
                          hint: 'votre@email.com',
                          keyboardType: TextInputType.emailAddress,
                          prefix: const Icon(Icons.email, color: kTeal),
                        ),
                        const SizedBox(height: 16),

                        // Password
                        SVTextField(
                          controller: passwordController,
                          label: 'Mot de passe',
                          hint: 'Entrez votre mot de passe',
                          isPassword: true,
                          prefix: const Icon(Icons.lock, color: kTeal),
                        ),
                        const SizedBox(height: 16),

                        // Confirm Password
                        SVTextField(
                          controller: confirmPasswordController,
                          label: 'Confirmer mot de passe',
                          hint: 'Confirmez votre mot de passe',
                          isPassword: true,
                          prefix: const Icon(Icons.lock, color: kTeal),
                        ),
                        const SizedBox(height: 24),

                        // Sign up button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSignUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kTeal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              disabledBackgroundColor: kTeal.withValues(alpha: 0.5),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Créer un compte',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Login link
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vous avez un compte ? ',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kTextSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        navigationTonextPage(context, const LoginPage());
                      },
                      child: Text(
                        'Se connecter',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kTeal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
