import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/screen/Athantification/login_page.dart';
import 'package:smarth_save/screen/pages/contact.dart';

class Navebar extends StatefulWidget {
  const Navebar({super.key});

  @override
  State<Navebar> createState() => _NavebarState();
}

class _NavebarState extends State<Navebar> {
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double fontSize,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        leading: Icon(icon, color: kPrimaryColor1),
        title: Text(title, style: TextStyle(fontSize: fontSize)),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double longeur = MediaQuery.of(context).size.height;
    return Drawer(
      child: Column(
        children: [
          // En-tête du Drawer
          Container(
            padding: EdgeInsets.symmetric(vertical: longeur / 20),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: kPrimaryColor1,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: largeur / 10,
                  backgroundImage:
                      const AssetImage('assets/images/image_one.png'),
                ),
                const SizedBox(height: 16),
                Text(
                  "${UserModel.sessionUser?.prenom} ${UserModel.sessionUser?.nom}",
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: largeur / 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w900),
                ),
                Text(
                  "${UserModel.sessionUser?.email}",
                  style: TextStyle(
                    fontSize: largeur / 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),]
              ),
            ),
            
          // Liste des options du menu
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                  vertical: longeur / 25, horizontal: largeur / 20),
              children: [
                _buildMenuItem(
                  icon: Icons.home_filled,
                  title: 'Accueil',
                  onTap: () {},
                  fontSize: largeur / 22,
                ),
                _buildMenuItem(
                  icon: Icons.account_circle_outlined,
                  title: 'Mon compte',
                  onTap: () {},
                  fontSize: largeur / 22,
                ),
                _buildMenuItem(
                  icon: Icons.account_balance_wallet,
                  title: 'Portefeuilles',
                  onTap: () {},
                  fontSize: largeur / 22,
                ),
                _buildMenuItem(
                  icon: Icons.notes,
                  title: 'Projets',
                  onTap: () {},
                  fontSize: largeur / 22,
                ),
                _buildMenuItem(
                  icon: Icons.notifications_none,
                  title: 'Notification',
                  onTap: () {},
                  fontSize: largeur / 22,
                ),
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Paramètres',
                  onTap: () {},
                  fontSize: largeur / 22,
                ),
                _buildMenuItem(
                  icon: Icons.account_box,
                  title: 'Nous contacter',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ContactPage()),
                    );
                  },
                  fontSize: largeur / 22,
                ),
              ],
            ),
          ),

          // Barre de navigation du bas
          Container(
            padding: const EdgeInsets.all(6),
            color: const Color(0xFF009688),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    UserModel.sessionUser?.logout();

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Déconnexion',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),
                TextButton.icon(
                  onPressed: () {
                    // TODO: Implement chatbot action
                  },
                  icon: SvgPicture.asset(
                    'assets/svg/boot.svg',
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    height: 24,
                  ),
                  label: const Text(
                    'ChatBot',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
      ]),
      );
    
  }
}
