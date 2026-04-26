import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/projet_model.dart';
import 'package:smarth_save/providers/projet_provider.dart';
import 'package:smarth_save/providers/userProvider.dart';
import 'package:smarth_save/widgets/projet_widgets.dart';

class DetailprojetPage extends StatefulWidget {
  final ProjetModel project;

  const DetailprojetPage({super.key, required this.project});

  @override
  State<DetailprojetPage> createState() => _DetailprojetPageState();
}

class _DetailprojetPageState extends State<DetailprojetPage> {
  late ProjetModel _project;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _project = widget.project;
  }

  void _showAddFundsModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => AddFundsModal(
        onConfirm: _handleAddFunds,
      ),
    );
  }

  Future<void> _handleAddFunds(double amount) async {
    final newMontant = _project.montant + amount;
    await context.read<ProjetProvider>().updateProjet(
          _project.id,
          montant: newMontant,
        );
    setState(() {
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
  }

  Future<void> _handleDeleteProject() async {
    final confirmed = await showDeleteConfirmationDialog(context);
    if (!confirmed) return;

    setState(() => _isLoading = true);
    try {
      await context.read<ProjetProvider>().deleteProjet(_project.id);
      if (mounted) context.go('/projet');
    } catch (e) {
      if (mounted) showErrorSnackbar(context, 'Erreur: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userPatrimoine = context.read<UserProvider>().user?.patrimoineEpargne ?? 0.0;

    final progress = userPatrimoine / _project.montant;

    return Scaffold(
      backgroundColor: kBgPage,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kNavyDark),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: kDanger),
            onPressed: _handleDeleteProject,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ProjectBanner(color: _project.color, imagePath: _project.image),
            FormCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProjectTitle(title: _project.titre),
                  if (_project.description != null &&
                      _project.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      _project.description!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kTextSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Center(
                    child: ProgressRing(
                      progress: progress,
                      color: _project.color,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AmountInfoRow(
                    savedAmount: userPatrimoine,
                    targetAmount: _project.montant,
                    color: _project.color,
                  ),
                  const SizedBox(height: 16),
                  DateDisplay(date: _project.dateVoulue),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Project banner ───────────────────────────────────────────────────────────

class _ProjectBanner extends StatelessWidget {
  final Color color;
  final String? imagePath;

  const _ProjectBanner({required this.color, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
      ),
      child: imagePath != null
          ? Image.network(
              imagePath!,
              fit: BoxFit.fitWidth,
            )
          : Center(
            child: Icon(
                Icons.folder_special_outlined,
                size: 80,
                color: Colors.white.withValues(alpha: 0.8),
              ),
          ),
    );
  }
}

// ─── Project title ───────────────────────────────────────────────────────────

class _ProjectTitle extends StatelessWidget {
  final String title;

  const _ProjectTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: kTextPrimary,
      ),
    );
  }
}
