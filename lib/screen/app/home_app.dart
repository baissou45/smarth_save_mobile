import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarth_save/screen/app/bottom_navbar.dart';

class HomeApp extends StatelessWidget {
  const HomeApp({required this.navigationShell, super.key});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    // Obtenez la route actuelle
    String currentLocation =
        GoRouter.of(context).routerDelegate.currentConfiguration.fullPath;

    print(currentLocation);

    // Vérifiez si la route actuelle nécessite de masquer la BottomNavigationBar
    bool shouldShowBottomNavBar = !isRouteWithoutBottomNavBar(currentLocation);

    // Log pour vérifier la route actuelle

    return Scaffold(
        body: navigationShell,
        bottomNavigationBar:
            shouldShowBottomNavBar
                ?
            ScaffoldWithNavBar(
          navigationShell: navigationShell,
        )
        : null,
        );
  }

  // // Fonction pour vérifier si la route actuelle doit masquer la BottomNavigationBar
  bool isRouteWithoutBottomNavBar(String location) {
    // Ajoutez les routes où vous ne voulez pas afficher la BottomNavigationBar
    List<String> routesWithoutBottomNavBar = [
      '/transactions','/moncompte', // Exemple de route spécifique
    ];
    return routesWithoutBottomNavBar.contains(location);
  }
}
