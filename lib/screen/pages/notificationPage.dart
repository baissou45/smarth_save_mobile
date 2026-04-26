import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              height: 160,
              decoration: const BoxDecoration(
                gradient: kHeaderGradient,
              ),
              child: Center(
                child: Text(
                  'Notifications',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Notifications list
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildNotificationCard(
                    'Projets',
                    'Nouveau projet ajouté avec succès',
                    'Maintenant',
                    Icons.folder_outlined,
                    false,
                  ),
                  _buildNotificationCard(
                    'Rapports',
                    'Votre rapport mensuel est disponible',
                    'il y a 10 minutes',
                    Icons.description_outlined,
                    false,
                  ),
                  _buildNotificationCard(
                    'Projets',
                    'Mettez à jour vos projets pour les mois à venir',
                    'il y a 2 heures',
                    Icons.refresh_outlined,
                    false,
                  ),
                  _buildNotificationCard(
                    'Alerte',
                    'Vos dépenses alimentaires ont atteint le seuil fixé',
                    'il y a 3 jours',
                    Icons.warning_outlined,
                    true,
                  ),
                  _buildNotificationCard(
                    'Banques',
                    'Votre nouvelle banque a été ajoutée avec succès',
                    '19/11/2024',
                    Icons.account_balance_outlined,
                    false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    String category,
    String message,
    String time,
    IconData icon,
    bool isAlert,
  ) {
    final iconColor = isAlert ? kDanger : kTeal;
    return Dismissible(
      key: Key('$category-$time'),
      onDismissed: (direction) {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: kBgCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: kNavyDark.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: kTextPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      time,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: kTextHint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
