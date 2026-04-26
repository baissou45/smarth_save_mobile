import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/categorie.dart';
import 'package:smarth_save/services/api_categorie_service.dart';

class AddCategoriePage extends StatefulWidget {
  final List<Categorie> availableCategories;
  final List<int> userCategoryIds;

  const AddCategoriePage({
    super.key,
    required this.availableCategories,
    required this.userCategoryIds,
  });

  @override
  State<AddCategoriePage> createState() => _AddCategoriePageState();
}

class _AddCategoriePageState extends State<AddCategoriePage> {
  final _formKey = GlobalKey<FormState>();
  Categorie? _selectedCategory;
  final plafondController = TextEditingController();
  bool _isLoading = false;
  int _currentStep = 0; // 0: selection, 1: budget

  @override
  void dispose() {
    plafondController.dispose();
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

  Future<void> _handleAddCategory() async {
    if (_selectedCategory == null) {
      _showError('Veuillez sélectionner une catégorie');
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final plafond = double.parse(plafondController.text);
      final apiService = ApiCategorieService();

      await apiService.addCategoryToUser(_selectedCategory!.id!, plafond);

      _showSuccess('Catégorie ajoutée avec succès!');
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.pop(context, {
          'category': _selectedCategory,
          'plafond': plafond,
        });
      }
    } catch (e) {
      _showError('Erreur: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter: show only categories not yet added by user
    final availableToAdd = widget.availableCategories
        .where((cat) => !widget.userCategoryIds.contains(cat.id))
        .toList();

    return Scaffold(
      backgroundColor: kBgPage,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kNavyDark),
          onPressed: () {
            if (_currentStep == 1) {
              setState(() => _currentStep = 0);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          _currentStep == 0 ? 'Nouvelle catégorie' : 'Définir le budget',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: kNavyDark,
          ),
        ),
        centerTitle: false,
      ),
      body: _currentStep == 0
          ? _buildCategorySelection(availableToAdd)
          : _buildBudgetInput(),
    );
  }

  // ─── Step 1: Category Selection ──────────────────────────────────────────

  Widget _buildCategorySelection(List<Categorie> availableToAdd) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Étape 1/2 · Sélectionnez votre catégorie',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: kTextSecondary,
              ),
            ),
            const SizedBox(height: 24),
            if (availableToAdd.isEmpty)
              Container(
                decoration: BoxDecoration(
                  color: kBgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: kTextHint, width: 1),
                ),
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          color: kSuccess, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        'Toutes les catégories sont déjà ajoutées',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: kTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: availableToAdd.length,
                itemBuilder: (context, index) {
                  final category = availableToAdd[index];
                  final isSelected =
                      _selectedCategory?.id == category.id;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                        plafondController.clear();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? category.color?.withValues(alpha: 0.1) : kBgCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? category.color ?? kTextHint : kTextHint,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? const [
                                BoxShadow(
                                  color: Color.fromARGB(38, 0, 150, 136),
                                  blurRadius: 12,
                                  offset: Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: (category.color ?? kTeal).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              category.icon,
                              color: category.color ?? kTeal,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              category.label ?? 'Catégorie',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: kTextPrimary,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 32),

            // Next button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _selectedCategory == null
                    ? null
                    : () => setState(() => _currentStep = 1),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kTeal,
                  disabledBackgroundColor: kTeal.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                label: Text(
                  'Continuer',
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
    );
  }

  // ─── Step 2: Budget Input ───────────────────────────────────────────────

  Widget _buildBudgetInput() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Étape 2/2 · Plafond mensuel',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: kTextSecondary,
              ),
            ),
            const SizedBox(height: 24),
            // Category preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kBgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (_selectedCategory?.color ?? kTeal)
                      .withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: (_selectedCategory?.color ?? kTeal)
                          .withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _selectedCategory?.icon,
                      color: _selectedCategory?.color ?? kTeal,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Catégorie sélectionnée',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: kTextSecondary,
                        ),
                      ),
                      Text(
                        _selectedCategory?.label ?? 'N/A',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: kTextPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Budget input
            Text(
              'Plafond mensuel',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: kTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: plafondController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kTextPrimary,
                ),
                decoration: InputDecoration(
                  hintText: '500.00',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: kTextSecondary,
                  ),
                  prefixIcon: const Icon(Icons.euro, color: kTeal),
                  filled: true,
                  fillColor: kBgCard,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: kTextHint,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: kTextHint,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: kTeal,
                      width: 2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un montant';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Format invalide';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Le montant doit être positif';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Définissez un budget limite mensuel pour cette catégorie',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: kTextSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        setState(() => _currentStep = 0),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      side: const BorderSide(color: kTeal, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Retour',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kTeal,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        _isLoading ? null : _handleAddCategory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kTeal,
                      disabledBackgroundColor:
                          kTeal.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            'Ajouter',
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
          ],
        ),
      ),
    );
  }
}
