import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

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
                  'Nous contacter',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Contact cards grid
            Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildContactCard(
                    'Email',
                    Icons.email_outlined,
                    kTeal,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('support@smartsave.com')),
                      );
                    },
                  ),
                  _buildContactCard(
                    'Téléphone',
                    Icons.phone_outlined,
                    kOrange,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('+33 (0)1 23 45 67 89')),
                      );
                    },
                  ),
                  _buildContactCard(
                    'GitHub',
                    Icons.code_outlined,
                    kNavyDark,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('github.com/smartsave')),
                      );
                    },
                  ),
                  _buildContactCard(
                    'Chat',
                    Icons.chat_outlined,
                    kTeal,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Chat en développement')),
                      );
                    },
                  ),
                  _buildContactCard(
                    'Urgence',
                    Icons.warning_outlined,
                    kDanger,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('+33 (0)9 87 65 43 21')),
                      );
                    },
                  ),
                  _buildContactCard(
                    'Site Web',
                    Icons.language_outlined,
                    kTeal,
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('smartsave.com')),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Info section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Container(
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Heures de support',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: kTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Lun - Ven', '9:00 - 18:00'),
                    _buildInfoRow('Samedi', '10:00 - 16:00'),
                    _buildInfoRow('Dimanche', 'Fermé'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kTextPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: kTextSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: kTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
