import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/theme/colors.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    backgroundColor: seedColor,
    selectedItemColor: kPrimaryColor,
    unselectedItemColor: Colors.black,
    currentIndex: navigationShell.currentIndex,
    showUnselectedLabels: true, // Assurez-vous que les labels non sélectionnés sont visibles
    selectedLabelStyle: TextStyle(color: Colors.black), // Style du label sélectionné
    unselectedLabelStyle: TextStyle(color: Colors.black), // Style du label non sélectionné
    onTap: (index) {
      navigationShell.goBranch(index);
    },
    items: [
      BottomNavigationBarItem(
        icon: SvgPicture.asset('assets/svg/home.svg', height: 22),
        activeIcon: SvgPicture.asset('assets/svg/home.svg', height: 24, color: kPrimaryColor),
        label: 'Accueil',
      ),
       BottomNavigationBarItem(
        icon:  SvgPicture.asset('assets/svg/portefeuille.svg', height: 22),
        activeIcon: SvgPicture.asset('assets/svg/portefeuille.svg', height: 24
        , color: kPrimaryColor,),
        label: 'Portfeuilles',
      ),
       BottomNavigationBarItem(
        icon: SvgPicture.asset('assets/svg/projects.svg', height: 22),
        activeIcon: SvgPicture.asset('assets/svg/projects.svg', height: 24, color:
        kPrimaryColor,),
        label: 'Projets',
      ),
       BottomNavigationBarItem(
        icon:  SvgPicture.asset('assets/svg/transaction.svg', height: 22),
        activeIcon: SvgPicture.asset('assets/svg/transaction.svg', height: 24
        , color: kPrimaryColor,),
        label: 'Transactions',
      ),
       BottomNavigationBarItem(
        icon: SvgPicture.asset('assets/svg/profil.svg', height: 22),
        activeIcon: SvgPicture.asset('assets/svg/profil.svg', height: 24, color
        : kPrimaryColor,),
        label: 'Mon compte',
      ),
    ],
  );
}

}
