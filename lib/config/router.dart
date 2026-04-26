import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarth_save/models/categorie.dart';
import 'package:smarth_save/models/projet_model.dart';
import 'package:smarth_save/screen/Athantification/login_page.dart';
import 'package:smarth_save/screen/pages/profil/contact.dart';
import 'package:smarth_save/screen/pages/monComptePage.dart';
import 'package:smarth_save/screen/pages/chat_bot_page.dart';
import 'package:smarth_save/screen/pages/notificationPage.dart';
import 'package:smarth_save/screen/pages/portfeuillesPage.dart';
import 'package:smarth_save/screen/pages/portfeuille/accounts_page.dart';
import 'package:smarth_save/screen/pages/profil/detail_compte.dart';
import 'package:smarth_save/screen/pages/profil/modifMotPass_page.dart';
import 'package:smarth_save/screen/pages/projet/creatProjet_page.dart';
import 'package:smarth_save/screen/pages/projet/detailProjet_page.dart';
import 'package:smarth_save/screen/pages/projet/projetPage.dart';
import 'package:smarth_save/screen/pages/transationPage.dart';
import 'package:smarth_save/screen/pages/transations/creatTrasation_page.dart';
import 'package:smarth_save/screen/pages/wellcommePage.dart';
import 'package:smarth_save/widgets/onbording.dart';
import 'package:smarth_save/widgets/redirectPage.dart';
import 'package:smarth_save/screen/app/home_app.dart';
import 'package:smarth_save/screen/pages/categories/add_categorie_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => RedirectPage(),
    ),
    // Route indépendante avec BottomNavigationBar
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/detailProjet',
      builder: (context, state) => DetailprojetPage(project: state.extra as ProjetModel),
    ),

    GoRoute(
      path: '/creatProjet',
      builder: (context, state) => const CreatprojetPage(),
    ),

    GoRoute(
      path: '/creatTransaction',
      builder: (context, state) => CreateTransactionPage(),
    ),
    GoRoute(
      path: '/modifProfile',
      builder: (context, state) => const DetailCompte(),
    ),
    GoRoute(
      path: '/chatbot',
      builder: (context, state) => const ChatBotPage(),
    ),
    GoRoute(
      path: '/modifMotPass',
      builder: (context, state) => const ModifmotpassPage(),
    ),
    GoRoute(
      path: '/addCategorie',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final categories = extra?['availableCategories'] as List? ?? [];
        final categoryIds = (extra?['userCategoryIds'] as List?)?.cast<int>() ?? const <int>[];
        return AddCategoriePage(
          availableCategories: categories.cast<Categorie>(),
          userCategoryIds: categoryIds,
        );
      },
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => OnbordingPage(onComplete: () async {
        // Redirection centralisee via RedirectPage: respecte isLoggedIn.
        context.go('/');
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
            GoRoute(
              path: '/notification',
              builder: (context, state) => const NotificationPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/portfeuilles',
              builder: (context, state) => const PortfeuillesPage(),
            ),
            GoRoute(
              path: '/accounts',
              builder: (context, state) => const AccountsPage(),
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
              path: '/transactions',
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
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/contact',
              builder: (context, state) => const ContactPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
