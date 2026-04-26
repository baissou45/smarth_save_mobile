import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/providers/projet_provider.dart';
import 'package:smarth_save/widgets/textfield.dart';
import 'package:smarth_save/widgets/projet_widgets.dart';

class CreatprojetPage extends StatefulWidget {
  const CreatprojetPage({super.key});

  @override
  State<CreatprojetPage> createState() => _CreatprojetPageState();
}

class _CreatprojetPageState extends State<CreatprojetPage> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _objectifController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _titreController.dispose();
    _descriptionController.dispose();
    _objectifController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _handleCreateProject() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      if (mounted) showErrorSnackbar(context, 'Veuillez sélectionner une date cible');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await context.read<ProjetProvider>().createProjet(
            titre: _titreController.text,
            description: _descriptionController.text,
            montantPrev: double.parse(_objectifController.text),
            dateVoulue: _selectedDate!,
          );
      if (mounted) context.go('/projet');
    } catch (e) {
      if (mounted) showErrorSnackbar(context, 'Erreur: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: kBgPage,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kNavyDark),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ProjetHeader(
              title: 'Créer un\nnouveau projet',
              subtitle: 'Définissez votre objectif d\'épargne',
            ),
            FormCard(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.01),
                    SVTextField(
                      controller: _titreController,
                      label: 'Titre du projet',
                      hint: 'Ex: Vacances en Italie',
                      keyboardType: TextInputType.text,
                      prefix: const Icon(Icons.title, color: kTeal),
                    ),
                    SizedBox(height: height * 0.03),
                    SVTextField(
                      controller: _descriptionController,
                      label: 'Description (optionnel)',
                      hint: 'Décrivez votre projet...',
                      keyboardType: TextInputType.text,
                      prefix: const Icon(Icons.description, color: kTeal),
                    ),
                    SizedBox(height: height * 0.03),
                    SVTextField(
                      controller: _objectifController,
                      label: 'Objectif (€)',
                      hint: 'Ex: 5000',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      prefix: const Icon(Icons.euro, color: kTeal),
                    ),
                    SizedBox(height: height * 0.03),
                    DatePickerField(
                      selectedDate: _selectedDate,
                      onTap: _selectDate,
                    ),
                    SizedBox(height: height * 0.03),
                    PrimaryButton(
                      label: 'Créer le projet',
                      onPressed: _handleCreateProject,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
