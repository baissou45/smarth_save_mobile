import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/providers/userProvider.dart';
import 'package:smarth_save/screen/Athantification/login_page.dart';
import 'package:smarth_save/screen/Athantification/sig_up.dart';
import 'package:smarth_save/screen/dashboard.dart';
import 'package:smarth_save/screen/onbording.dart';
import 'package:smarth_save/screen/pages/wellcommePage.dart';

class Redirectpage extends StatefulWidget {
  @override
  _RedirectpageState createState() => _RedirectpageState();
}

class _RedirectpageState extends State<Redirectpage> {
  @override
  void initState() {
    super.initState();
    UserModel.getUser();
    _checkOnboardingStatus();
    FlutterNativeSplash.remove();
  }

  Future<void> loadtoken() async {}

  Future<void> _checkOnboardingStatus() async {
    final userProvider = UserProvider();
    await userProvider
        .loadToken(); // Charge le token avant d'afficher l'application;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    if (hasSeenOnboarding) {
      if (userProvider.isLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Wellcommepage()),
        );
      } else {
        // Naviguer vers l'écran principal si l'onboarding a déjà été vu
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } else {
      // Afficher l'onboarding si ce n'est pas le cas
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => OnbordingPage(onComplete: () async {
                  // Mettre à jour l'état de l'onboarding une fois terminé
                  await prefs.setBool('hasSeenOnboarding', true);
                })),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:Text("")
    );
  }
}
