import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/providers/userProvider.dart';

class RedirectPage extends StatefulWidget {
  const RedirectPage({super.key});

  @override
  State<RedirectPage> createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  @override
  void initState() {
    super.initState();
    _redirectUser();
  }

  Future<void> _redirectUser() async {
    await UserModel.getUser();

    final userProvider = context.read<UserProvider>();
    await userProvider.loadToken();

    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

    final targetRoute =
        _getTargetRoute(hasSeenOnboarding, userProvider.isLoggedIn);

    if (!mounted) return;
    context.go(targetRoute);
    FlutterNativeSplash.remove();
  }

  String _getTargetRoute(bool hasSeenOnboarding, bool isLoggedIn) {
    // On priorise la session active: utilisateur connecté -> accueil direct.
    if (isLoggedIn) {
      return '/accueil';
    }
    if (!hasSeenOnboarding) {
      return '/onboarding';
    }
    return '/login';
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
