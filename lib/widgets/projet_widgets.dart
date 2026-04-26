import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';

// ─── Snackbar utilities ───────────────────────────────────────────────────────

void showErrorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: kDanger,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

void showSuccessSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: kSuccess,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}

// ─── Date picker widget ───────────────────────────────────────────────────────

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const DatePickerField({
    required this.selectedDate,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selectedDate != null ? kTeal : kTextHint,
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: kTeal, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                        : 'Sélectionner une date',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: selectedDate != null ? kTextPrimary : kTextHint,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Primary button ───────────────────────────────────────────────────────────

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kTeal,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          disabledBackgroundColor: kTeal.withValues(alpha: 0.5),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

// ─── Header section ───────────────────────────────────────────────────────────

class ProjetHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const ProjetHeader({
    required this.title,
    required this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: const BoxDecoration(gradient: kHeaderGradient),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: kTealLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Form card wrapper ───────────────────────────────────────────────────────

class FormCard extends StatelessWidget {
  final Widget child;

  const FormCard({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
        child: child,
      ),
    );
  }
}

// ─── Progress ring ───────────────────────────────────────────────────────────

class ProgressRing extends StatelessWidget {
  final double progress;
  final Color color;
  final double size;

  const ProgressRing({
    required this.progress,
    required this.color,
    this.size = 120,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size * 0.9,
            height: size * 0.9,
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, progress),
              strokeWidth: 6,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${(progress * 100).round()}%',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: color,
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
    );
  }
}

// ─── Amount info row ───────────────────────────────────────────────────────────

class AmountInfoRow extends StatelessWidget {
  final double savedAmount;
  final double targetAmount;
  final Color color;

  const AmountInfoRow({
    required this.savedAmount,
    required this.targetAmount,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
              '${savedAmount.toStringAsFixed(2)} €',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
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
              '${targetAmount.toStringAsFixed(2)} €',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: kTextPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Date display ───────────────────────────────────────────────────────────

class DateDisplay extends StatelessWidget {
  final DateTime? date;

  const DateDisplay({required this.date, super.key});

  @override
  Widget build(BuildContext context) {
    if (date == null) return const SizedBox.shrink();

    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 16, color: kTeal),
        const SizedBox(width: 8),
        Text(
          'Date cible: ${date.toString().split(' ')[0]}',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: kTextSecondary,
          ),
        ),
      ],
    );
  }
}

// ─── Delete confirmation dialog ───────────────────────────────────────────────

Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
  final result = await showDialog<bool>(
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
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Annuler',
            style: GoogleFonts.poppins(
              color: kTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
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
  return result ?? false;
}

// ─── Add funds modal bottom sheet ───────────────────────────────────────────

class AddFundsModal extends StatefulWidget {
  final Function(double amount) onConfirm;

  const AddFundsModal({required this.onConfirm, super.key});

  @override
  State<AddFundsModal> createState() => _AddFundsModalState();
}

class _AddFundsModalState extends State<AddFundsModal> {
  final _montantController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _montantController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    FocusScope.of(context).unfocus();
    if (_montantController.text.isEmpty) {
      showErrorSnackbar(context, 'Veuillez entrer un montant');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await widget.onConfirm(double.parse(_montantController.text));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      showErrorSnackbar(context, 'Erreur: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          TextField(
            controller: _montantController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Montant (€)',
              hintText: 'Ex: 500',
              prefixIcon: const Icon(Icons.euro, color: kTeal),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Confirmer',
            onPressed: _handleSubmit,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}
