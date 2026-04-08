import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/providers/projet_provider.dart';
import 'package:smarth_save/widgets/textfield.dart';

class CreatprojetPage extends StatefulWidget {
  const CreatprojetPage({super.key});

  @override
  State<CreatprojetPage> createState() => _CreatprojetPageState();
}

class _CreatprojetPageState extends State<CreatprojetPage> {
  final _formKey = GlobalKey<FormState>();
  final titreController = TextEditingController();
  final descriptionController = TextEditingController();
  final objectifController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void dispose() {
    titreController.dispose();
    descriptionController.dispose();
    objectifController.dispose();
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

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _handleCreateProject() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      _showError('Veuillez sélectionner une date cible');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await context.read<ProjetProvider>().createProjet(
            titre: titreController.text,
            description: descriptionController.text,
            montantPrev: double.parse(objectifController.text),
            dateVoulue: _selectedDate!,
          );
      if (mounted) {
        context.go('/projet');
      }
    } catch (e) {
      _showError('Erreur: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
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
          onPressed: () => context.go('/projet'),
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
                      'Créer un\nnouveau projet',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Définissez votre objectif d\'épargne',
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
                      // Titre
                      SVTextField(
                        controller: titreController,
                        label: 'Titre du projet',
                        hint: 'Ex: Vacances en Italie',
                        keyboardType: TextInputType.text,
                        prefix: const Icon(Icons.title, color: kTeal),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      SVTextField(
                        controller: descriptionController,
                        label: 'Description (optionnel)',
                        hint: 'Décrivez votre projet...',
                        keyboardType: TextInputType.text,
                        prefix: const Icon(Icons.description, color: kTeal),
                      ),
                      const SizedBox(height: 16),

                      // Objectif montant
                      SVTextField(
                        controller: objectifController,
                        label: 'Objectif (€)',
                        hint: 'Ex: 5000',
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        prefix: const Icon(Icons.euro, color: kTeal),
                      ),
                      const SizedBox(height: 16),

                      // Date cible
                      Text(
                        'Date cible',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: _selectDate,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _selectedDate != null ? kTeal : kTextHint,
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: kTeal,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedDate != null
                                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                      : 'Sélectionner une date',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _selectedDate != null
                                        ? kTextPrimary
                                        : kTextHint,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Create button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleCreateProject,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kTeal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            disabledBackgroundColor:
                                kTeal.withValues(alpha: 0.5),
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
                                  'Créer le projet',
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
