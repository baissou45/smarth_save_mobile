import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/categorie.dart';
import 'package:smarth_save/widgets/textfield.dart';

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

  Future<void> _handleAddCategory() async {
    if (_selectedCategory == null) {
      _showError('Veuillez sélectionner une catégorie');
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      // TODO: Call POST /api/users_categories/{id} endpoint
      Navigator.pop(context, {
        'category': _selectedCategory,
        'plafond': double.parse(plafondController.text),
      });
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
          onPressed: () => Navigator.pop(context),
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
                      'Ajouter une\ncatégorie',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Définissez votre budget mensuel',
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

            // Category selection
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Catégories disponibles',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: kTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (availableToAdd.isEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: kBgCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: kTextHint, width: 1),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'Toutes les catégories sont déjà ajoutées',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: kTextSecondary,
                          ),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: kBgCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? kTeal : kTextHint,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: kTeal.withValues(alpha: 0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: kTeal.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.category,
                                    color: kTeal,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    category.label ?? 'Catégorie',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                      color: kTextPrimary,
                                    ),
                                  ),
                                ),
                                Radio<Categorie>(
                                  value: category,
                                  groupValue: _selectedCategory,
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedCategory = value;
                                        plafondController.clear();
                                      });
                                    }
                                  },
                                  activeColor: kTeal,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 24),

                  // Plafond input (appears after selection)
                  if (_selectedCategory != null) ...[
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
                      child: SVTextField(
                        controller: plafondController,
                        label: 'Montant en €',
                        hint: 'Ex: 500.00',
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        prefix: const Icon(Icons.euro, color: kTeal),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Add button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleAddCategory,
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
                                'Ajouter la catégorie',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
