import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/screen/Athantification/login_page.dart';
import 'package:smarth_save/screen/pages/contact.dart';
import 'package:smarth_save/screen/pages/monComptePage.dart';
import 'package:smarth_save/screen/pages/chat_bot_page.dart';
import 'package:smarth_save/screen/pages/notificationPage.dart';
import 'package:smarth_save/screen/pages/portfeuillesPage.dart';
import 'package:smarth_save/screen/pages/profil/detail_compte.dart';
import 'package:smarth_save/screen/pages/profil/modifMotPass_page.dart';
import 'package:smarth_save/screen/pages/projet/creatProjet_page.dart';
import 'package:smarth_save/screen/pages/projet/detailProjet_page.dart';
import 'package:smarth_save/screen/pages/projet/projetPage.dart';
import 'package:smarth_save/screen/pages/transationPage.dart';
import 'package:smarth_save/screen/pages/transations/transationScreen.dart';
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
    // Route indépendante avec BottomNavigationBar
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/detailleProjet',
      builder: (context, state) => DetailprojetPage(),
    ),
    GoRoute(
      path: '/chatbot',
      builder: (context, state) => const ChatBotPage(),
    ),
    GoRoute(
      path: '/transaction/:type',
      builder: (context, state) {
        final type = state.pathParameters['type']!;
        return Scaffold(
          body: TransactionScreen(type: type),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: seedColor,
            // selectedItemColor: kPrimaryColor,
            unselectedItemColor: Colors.black,
            showUnselectedLabels:
                true, // ✅ Assurez-vous que les labels sont visibles
            showSelectedLabels:
                true, // ✅ Ajouté pour être sûr que les labels s'affichent
            // currentIndex: 3, // Correspond à l'onglet Transactions
            onTap: (index) {
              context.go([
                '/accueil',
                '/portfeuilles',
                '/projets',
                '/transactions',
                '/moncompte'
              ][index]);
            },
            items: [
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    SvgPicture.asset("assets/svg/home.svg", height: 22),
                    SizedBox(
                        height: 4), // ✅ Ajouté pour forcer l'affichage du texte
                  ],
                ),
                activeIcon: Column(
                  children: [
                    SvgPicture.asset("assets/svg/home.svg",
                        height: 24, color: kPrimaryColor1),
                    SizedBox(height: 4), // ✅ Ajouté
                  ],
                ),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    SvgPicture.asset("assets/svg/portefeuille.svg", height: 22),
                    SizedBox(height: 4),
                  ],
                ),
                activeIcon: Column(
                  children: [
                    SvgPicture.asset("assets/svg/portefeuille.svg",
                        height: 24, color: kPrimaryColor1),
                    SizedBox(height: 4),
                  ],
                ),
                label: 'Portfeuilles',
              ),
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    SvgPicture.asset("assets/svg/projects.svg", height: 22),
                    SizedBox(height: 4),
                  ],
                ),
                activeIcon: Column(
                  children: [
                    SvgPicture.asset("assets/svg/projects.svg",
                        height: 24, color: kPrimaryColor1),
                    SizedBox(height: 4),
                  ],
                ),
                label: 'Projets',
              ),
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    SvgPicture.asset("assets/svg/transaction.svg", height: 22),
                    SizedBox(height: 4),
                  ],
                ),
                activeIcon: Column(
                  children: [
                    SvgPicture.asset("assets/svg/transaction.svg",
                        height: 24, color: kPrimaryColor1),
                    SizedBox(height: 4),
                  ],
                ),
                label: 'Transactions',
              ),
              BottomNavigationBarItem(
                icon: Column(
                  children: [
                    SvgPicture.asset("assets/svg/profil.svg", height: 22),
                    SizedBox(height: 4),
                  ],
                ),
                activeIcon: Column(
                  children: [
                    SvgPicture.asset("assets/svg/profil.svg",
                        height: 24, color: kPrimaryColor1),
                    SizedBox(height: 4),
                  ],
                ),
                label: 'Mon compte',
              ),
            ],
          ),
        );
      },
    ),

    GoRoute(
      path: '/creatProjet',
      builder: (context, state) => const CreatprojetPage(),
    ),
    GoRoute(
      path: '/modifProfile',
      builder: (context, state) => const DetailCompte(),
    ),
    GoRoute(
      path: '/modifMotPass',
      builder: (context, state) => const ModifmotpassPage(),
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
        // StatefulShellBranch(
        //   routes: [
        //     GoRoute(
        //       path: '/transatdatail',
        //       builder: (context, state) =>  TransactionScreen(type: "credit"),
        //     ),
        //   ],
        // ),
      ],
    ),
  ],
);
