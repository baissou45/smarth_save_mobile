import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarth_save/screen/Athantification/login_page.dart';
import 'package:smarth_save/screen/pages/monComptePage.dart';
import 'package:smarth_save/screen/pages/portfeuillesPage.dart';
import 'package:smarth_save/screen/pages/projetPage.dart';
import 'package:smarth_save/screen/pages/transationPage.dart';
import 'package:smarth_save/screen/pages/wellcommePage.dart';
import 'package:smarth_save/widgets/onbording.dart';
import 'package:smarth_save/widgets/redirectPage.dart';
import 'package:smarth_save/screen/app/home_app.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => RedirectPage(),
    ),
    GoRoute(
    path: '/login',
    builder: (context, state) =>  LoginPage(),
  ),
    GoRoute(
    path: '/onboarding',
    builder: (context, state) => OnbordingPage(onComplete: () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenOnboarding', true);
      context.go('/accueil');
    }),
  ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeApp(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/accueil',
              builder: (context, state) => const Wellcommepage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/portfeuilles',
              builder: (context, state) => const PortfeuillesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/projets',
              builder: (context, state) => const ProjetPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/transations',
              builder: (context, state) => const TransationPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/moncompte',
              builder: (context, state) => const MonComptePage(),
            ),
          ],
        )
      ],
    ),
  ],
);
