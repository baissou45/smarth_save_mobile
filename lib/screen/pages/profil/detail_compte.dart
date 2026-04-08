import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/services/api_user_service.dart';
import 'package:smarth_save/widgets/textfield.dart';

class DetailCompte extends StatefulWidget {
  const DetailCompte({super.key});

  @override
  State<DetailCompte> createState() => _DetailCompteState();
}

class _DetailCompteState extends State<DetailCompte> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nomController;
  late TextEditingController prenomController;
  late TextEditingController emailController;
  bool _isLoading = false;
  final ApiUserService _apiUserService = ApiUserService();

  @override
  void initState() {
    super.initState();
    final user = UserModel.sessionUser;
    nomController = TextEditingController(text: user?.nom ?? '');
    prenomController = TextEditingController(text: user?.prenom ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    emailController.dispose();
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

  Future<void> _handleSave() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _apiUserService.updateProfile(
        nom: nomController.text,
        prenom: prenomController.text,
        email: emailController.text,
      );
      _showSuccess('Profil mis à jour avec succès');
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        context.go('/moncompte');
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
    final user = UserModel.sessionUser;
    final initials =
        '${user?.prenom?.isNotEmpty == true ? user!.prenom![0] : ''}${user?.nom?.isNotEmpty == true ? user!.nom![0] : ''}'
            .toUpperCase();

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
            // Header gradient avec avatar
            Container(
              height: 200,
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
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: kTeal,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Mon profil',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
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
                      SVTextField(
                        controller: nomController,
                        label: 'Nom',
                        hint: 'Votre nom',
                        keyboardType: TextInputType.name,
                        prefix: const Icon(Icons.person, color: kTeal),
                      ),
                      const SizedBox(height: 16),

                      SVTextField(
                        controller: prenomController,
                        label: 'Prénom',
                        hint: 'Votre prénom',
                        keyboardType: TextInputType.name,
                        prefix: const Icon(Icons.person, color: kTeal),
                      ),
                      const SizedBox(height: 16),

                      SVTextField(
                        controller: emailController,
                        label: 'Email',
                        hint: 'votre@email.com',
                        keyboardType: TextInputType.emailAddress,
                        prefix: const Icon(Icons.email, color: kTeal),
                      ),
                      const SizedBox(height: 24),

                      // Change password button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () => context.go('/modifMotPass'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: kTeal, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Changer le mot de passe',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: kTeal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Save button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSave,
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
                                  'Enregistrer',
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
          ],
        ),
      ),
    );
  }
}
