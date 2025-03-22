import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/providers/userProvider.dart';
import 'package:go_router/go_router.dart';

class RedirectPage extends StatefulWidget {
  @override
  _RedirectPageState createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  @override
  void initState() {
    super.initState();
    UserModel.getUser();
    _checkOnboardingStatus();
    FlutterNativeSplash.remove();
  }

  Future<void> _checkOnboardingStatus() async {
    final userProvider = UserProvider();
    await userProvider.loadToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    // Déterminez la route en fonction de l'état de l'onboarding et de l'authentification
    String targetRoute = _getTargetRoute(hasSeenOnboarding, userProvider.isLoggedIn);

    // Utilisez GoRouter pour naviguer vers la route cible
    context.go(targetRoute);
  }

  String _getTargetRoute(bool hasSeenOnboarding, bool isLoggedIn) {
    if (hasSeenOnboarding) {
      return isLoggedIn ? '/accueil' : '/login';
    } else {
      return '/onboarding';
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()), // Affiche un indicateur de chargement pendant la redirection
    );
  }
}
