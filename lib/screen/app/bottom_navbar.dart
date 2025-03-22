import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/theme/colors.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: seedColor,
    selectedItemColor: kPrimaryColor,
    unselectedItemColor: kPrimaryColor1,
    currentIndex: navigationShell.currentIndex,
    showUnselectedLabels: true, // Assurez-vous que les labels non sélectionnés sont visibles
    selectedLabelStyle: TextStyle(color: Colors.black), // Style du label sélectionné
    unselectedLabelStyle: TextStyle(color: Colors.black), // Style du label non sélectionné
    onTap: (index) {
      navigationShell.goBranch(index);
    },
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Accueil',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_balance_wallet),
        label: 'Portfeuilles',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.work),
        label: 'Projets',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.swap_horiz),
        label: 'Transactions',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Mon compte',
      ),
    ],
  );
}

}
