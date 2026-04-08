import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/projet_model.dart';
import 'package:smarth_save/providers/projet_provider.dart';
import 'package:smarth_save/widgets/textfield.dart';

class DetailprojetPage extends StatefulWidget {
  final ProjetModel project;

  const DetailprojetPage({super.key, required this.project});

  @override
  State<DetailprojetPage> createState() => _DetailprojetPageState();
}

class _DetailprojetPageState extends State<DetailprojetPage> {
  late ProjetModel _project;
  final montantController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _project = widget.project;
  }

  @override
  void dispose() {
    montantController.dispose();
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

  void _showAddFundsModal() {
    montantController.clear();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ajouter des fonds',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: kTextPrimary,
              ),
            ),
            const SizedBox(height: 20),
            SVTextField(
              controller: montantController,
              label: 'Montant (€)',
              hint: 'Ex: 500',
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              prefix: const Icon(Icons.euro, color: kTeal),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        if (montantController.text.isEmpty) {
                          _showError('Veuillez entrer un montant');
                          return;
                        }

                        setState(() => _isLoading = true);
                        try {
                          final newMontant = _project.montant +
                              double.parse(montantController.text);
                          await context.read<ProjetProvider>().updateProjet(
                                _project.id,
                                montant: newMontant,
                              );
                          setState(() {
                            _project = _project;
                            _project = ProjetModel(
                              id: _project.id,
                              titre: _project.titre,
                              montant: newMontant,
                              montantPrev: _project.montantPrev,
                              progress: newMontant / _project.montantPrev,
                              color: _project.color,
                              image: _project.image,
                              description: _project.description,
                              dateVoulue: _project.dateVoulue,
                            );
                          });
                          _showSuccess('Fonds ajoutés avec succès');
                          if (mounted) Navigator.pop(context);
                        } catch (e) {
                          _showError('Erreur: ${e.toString()}');
                        } finally {
                          setState(() => _isLoading = false);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: kTeal.withValues(alpha: 0.5),
                ),
                child: Text(
                  'Confirmer',
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

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Supprimer ce projet ?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: kTextPrimary,
          ),
        ),
        content: Text(
          'Cette action est irréversible.',
          style: GoogleFonts.poppins(color: kTextSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: GoogleFonts.poppins(
                color: kTextSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isLoading = true);
              try {
                await context
                    .read<ProjetProvider>()
                    .deleteProjet(_project.id);
                if (mounted) {
                  context.go('/projet');
                }
              } catch (e) {
                _showError('Erreur: ${e.toString()}');
              } finally {
                setState(() => _isLoading = false);
              }
            },
            child: Text(
              'Supprimer',
              style: GoogleFonts.poppins(
                color: kDanger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _project.montant / _project.montantPrev;

    return Scaffold(
      backgroundColor: kBgPage,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kNavyDark),
          onPressed: () => context.go('/projet'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: kDanger),
            onPressed: _showDeleteDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner with image/icon
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: _project.color,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.folder_special_outlined,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),

            // Details card
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      _project.titre,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: kTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    if (_project.description != null &&
                        _project.description!.isNotEmpty)
                      Text(
                        _project.description!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: kTextSecondary,
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Progress ring
                    Center(
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: progress.clamp(0.0, 1.0),
                              strokeWidth: 6,
                              backgroundColor:
                                  _project.color.withValues(alpha: 0.1),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  _project.color),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${(progress * 100).round()}%',
                                  style: GoogleFonts.poppins(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: _project.color,
                                  ),
                                ),
                                Text(
                                  'Réussi',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: kTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Amount info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Épargné',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: kTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_project.montant.toStringAsFixed(2)} €',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: _project.color,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Objectif',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: kTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_project.montantPrev.toStringAsFixed(2)} €',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: kTextPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Date
                    if (_project.dateVoulue != null)
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: kTeal),
                          const SizedBox(width: 8),
                          Text(
                            'Date cible: ${_project.dateVoulue.toString().split(' ')[0]}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: kTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),

                    // Add funds button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _showAddFundsModal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kTeal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Ajouter des fonds',
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
          ],
        ),
      ),
    );
  }
}
