import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarth_save/screen/app/bottom_navbar.dart';

class HomeApp extends StatelessWidget {
  const HomeApp({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: ScaffoldWithNavBar(
        navigationShell: navigationShell,
      ),
    );
  }
}
