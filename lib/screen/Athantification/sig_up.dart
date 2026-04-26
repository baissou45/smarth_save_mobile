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
  bool _showPassword = false;
  bool _showConfirmPassword = false;

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        nomController.text,
        prenomController.text,
        emailController.text,
        passwordController.text,
      );
    } catch (e) {
      _showError('Erreur d\'inscription: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignUp() async {
    setState(() => _isLoading = true);
    try {
      await AutheControllers().loginWithGoogle(context);
    } catch (e) {
      _showError('Erreur Google: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgPage,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header gradient
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: kHeaderGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Inscription',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rejoignez l\'aventure SmartSave',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Form content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nom et Prénom en ligne
                    Row(
                      children: [
                        Expanded(
                          child: SVTextField(
                            controller: nomController,
                            label: 'Nom',
                            hint: 'Nom',
                            keyboardType: TextInputType.name,
                            prefix: const Icon(Icons.person_outline, color: kTeal, size: 20),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SVTextField(
                            controller: prenomController,
                            label: 'Prénom',
                            hint: 'Prénom',
                            keyboardType: TextInputType.name,
                            prefix: const Icon(Icons.person_outline, color: kTeal, size: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Email
                    SVTextField(
                      controller: emailController,
                      label: 'Email',
                      hint: 'votre@email.com',
                      keyboardType: TextInputType.emailAddress,
                      prefix: const Icon(Icons.email_outlined, color: kTeal, size: 20),
                    ),
                    const SizedBox(height: 20),

                    // Password
                    SVTextField(
                      controller: passwordController,
                      label: 'Mot de passe',
                      hint: 'Votre mot de passe',
                      isPassword: !_showPassword,
                      prefix: const Icon(Icons.lock_outline, color: kTeal, size: 20),
                      suffix: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: kTextSecondary,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() => _showPassword = !_showPassword);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password
                    SVTextField(
                      controller: confirmPasswordController,
                      label: 'Confirmation',
                      hint: 'Confirmez le mot de passe',
                      isPassword: !_showConfirmPassword,
                      prefix: const Icon(Icons.lock_outline, color: kTeal, size: 20),
                      suffix: IconButton(
                        icon: Icon(
                          _showConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: kTextSecondary,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() =>
                              _showConfirmPassword = !_showConfirmPassword);
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Sign up button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kTeal,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
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
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Créer mon compte',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: kTextSecondary.withValues(alpha: 0.2),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'ou',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: kTextSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: kTextSecondary.withValues(alpha: 0.2),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Google signup button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : _handleGoogleSignUp,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: kTextSecondary.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/googleBtn.png',
                              height: 24,
                              width: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'S\'inscrire avec Google',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: kTextPrimary,
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

            // Login footer
            Padding(
              padding: const EdgeInsets.only(bottom: 40, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Vous avez déjà un compte ? ',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: kTextSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
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
    );
  }
}
