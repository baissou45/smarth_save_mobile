import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarth_save/outils/navigation.dart';
import 'package:smarth_save/providers/userProvider.dart';
import 'package:smarth_save/screen/Athantification/sig_up.dart';
import 'package:smarth_save/screen/widget/onbordWidget.dart';
import 'package:smarth_save/screen/widget/onbordingBtn.dart';

class OnbordingPage extends StatefulWidget {
  final VoidCallback onComplete;
  const OnbordingPage({super.key, required this.onComplete});

  @override
  State<OnbordingPage> createState() => _OnbordingPageState();
}

class _OnbordingPageState extends State<OnbordingPage> {
  final List<Widget> swipeableBody = [
    onboard("image_one.png", "Suivez facilement vos finances.",
        "Connectez vos comptes bancaires en toute sécurité et suivez vos revenus, dépenses et soldes en temps réel, tout-en-un seul endroit."),
    onboard("image_two.png", "Atteignez vos objectifs financiers.",
        "Definissez vos objectifs (achat, épagne, insetissement) et laisse l'application vous guider avec des plans de personnalisés pour les atteindre plus rapidement."),
    onboard("image_three.png", "Recevez des conseils intelligents.",
        "L'application analyse cos habitudes financières et vous propose des recommandations pour économiser, mieux gerer votre budget et optimiser vos dépenses.")
  ];
  int startIndex = 0;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
        body: PageView.builder(
            controller: PageController(initialPage: startIndex),
            itemCount: swipeableBody.length,
            onPageChanged: (currentIndex) {
              setState(() {
                startIndex = currentIndex;
              });
            },
            itemBuilder: (context, index) {
              return swipeableBody[
                  index]; // Utilisez 'index' au lieu de 'startIndex'
            }),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (startIndex > 0)
                  onbordingBtn(
                      label: "Précédent",
                      onPressed: () => setState(() {
                            startIndex -= 1;
                          }))
                else
                  const SizedBox.shrink(),
                startIndex == 0
                    ? onbordingBtn(
                        label: "Commencer",
                        onPressed: () => setState(() {
                              startIndex += 1;
                            }))
                    : startIndex == swipeableBody.length - 1
                        ? onbordingBtn(
                            label: "C'est parti !",
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool('hasSeenOnboarding', true);
                              navigationTonextPage(context, SigUpPage());
                            })
                        : onbordingBtn(
                            label: "Suivant",
                            onPressed: () => setState(() {
                                  startIndex += 1;
                                }))
              ],
            )));
  }
}
