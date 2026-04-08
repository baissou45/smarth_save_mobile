import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/services/api_user_service.dart';
import 'package:smarth_save/widgets/textfield.dart';

class ModifmotpassPage extends StatefulWidget {
  const ModifmotpassPage({super.key});

  @override
  State<ModifmotpassPage> createState() => _ModifmotpassPageState();
}

class _ModifmotpassPageState extends State<ModifmotpassPage> {
  final _formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  final ApiUserService _apiUserService = ApiUserService();

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
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

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: kSuccess,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _handleChangePassword() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    if (newPasswordController.text != confirmPasswordController.text) {
      _showError('Les nouveaux mots de passe ne correspondent pas');
      return;
    }

    if (newPasswordController.text == oldPasswordController.text) {
      _showError('Le nouveau mot de passe doit être différent de l\'ancien');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _apiUserService.changePassword(
        oldPassword: oldPasswordController.text,
        password: newPasswordController.text,
        passwordConfirmation: confirmPasswordController.text,
      );
      _showSuccess('Mot de passe modifié avec succès. Veuillez vous reconnecter.');
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      _showError('Erreur: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgPage,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kNavyDark),
          onPressed: () => context.go('/moncompte'),
        ),
      ),
      body: SingleChildScrollView(
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
                      'Changer\nmot de passe',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sécurisez votre compte',
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

            // Form card
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
                      // Old password
                      SVTextField(
                        controller: oldPasswordController,
                        label: 'Ancien mot de passe',
                        hint: 'Entrez votre ancien mot de passe',
                        isPassword: true,
                        prefix: const Icon(Icons.lock, color: kTeal),
                      ),
                      const SizedBox(height: 16),

                      // New password
                      SVTextField(
                        controller: newPasswordController,
                        label: 'Nouveau mot de passe',
                        hint: 'Entrez votre nouveau mot de passe',
                        isPassword: true,
                        prefix: const Icon(Icons.lock, color: kTeal),
                      ),
                      const SizedBox(height: 16),

                      // Confirm password
                      SVTextField(
                        controller: confirmPasswordController,
                        label: 'Confirmer mot de passe',
                        hint: 'Confirmez votre nouveau mot de passe',
                        isPassword: true,
                        prefix: const Icon(Icons.lock, color: kTeal),
                      ),
                      const SizedBox(height: 24),

                      // Change password button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleChangePassword,
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
                                  'Modifier mot de passe',
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

            // Info text
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Assurez-vous que votre mot de passe contient au moins 8 caractères et est sécurisé.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: kTextSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
