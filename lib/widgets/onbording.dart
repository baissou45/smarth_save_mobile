import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarth_save/outils/navigation.dart';
import 'package:smarth_save/screen/Athantification/sig_up.dart';
import 'package:smarth_save/widgets/onbordWidget.dart';
import 'package:smarth_save/widgets/onbordingBtn.dart';

class OnbordingPage extends StatefulWidget {
  final VoidCallback onComplete;
  const OnbordingPage({super.key, required this.onComplete});

  @override
  State<OnbordingPage> createState() => _OnbordingPageState();
}

class _OnbordingPageState extends State<OnbordingPage> {
  final PageController _pageController = PageController();
  int startIndex = 0;

  final List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      image: "image_one.png",
      title: "Suivez facilement vos finances.",
      description:
          "Connectez vos comptes bancaires en toute sécurité et suivez vos revenus, dépenses et soldes en temps réel, tout-en-un seul endroit.",
    ),
    OnboardingItem(
      image: "image_two.png",
      title: "Atteignez vos objectifs financiers.",
      description:
          "Définissez vos objectifs (achat, épargne, investissement) et laissez l'application vous guider avec des plans personnalisés pour les atteindre plus rapidement.",
    ),
    OnboardingItem(
      image: "image_three.png",
      title: "Recevez des conseils intelligents.",
      description:
          "L'application analyse vos habitudes financières et vous propose des recommandations pour économiser, mieux gérer votre budget et optimiser vos dépenses.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: onboardingItems.length,
        onPageChanged: (currentIndex) {
          setState(() {
            startIndex = currentIndex;
          });
        },
        itemBuilder: (context, index) {
          return onboard(
            onboardingItems[index].image,
            onboardingItems[index].title,
            onboardingItems[index].description,
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (startIndex > 0)
              onbordingBtn(
                label: "Précédent",
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              )
            else
              const SizedBox.shrink(),
            startIndex == onboardingItems.length - 1
                ? onbordingBtn(
                    label: "C'est parti !",
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('hasSeenOnboarding', true);
                      navigationTonextPage(context, SigUpPage());
                    },
                  )
                : onbordingBtn(
                    label: "Suivant",
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class OnboardingItem {
  final String image;
  final String title;
  final String description;

  OnboardingItem({required this.image, required this.title, required this.description});
}
