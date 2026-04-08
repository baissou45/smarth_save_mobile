import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarth_save/widgets/onbordWidget.dart';
import 'package:smarth_save/widgets/onbordingBtn.dart';

typedef OnboardingCompleteCallback = Future<void> Function();

class OnbordingPage extends StatefulWidget {
  final OnboardingCompleteCallback onComplete;
  const OnbordingPage({super.key, required this.onComplete});

  @override
  State<OnbordingPage> createState() => _OnbordingPageState();
}

class _OnbordingPageState extends State<OnbordingPage> {
  final PageController _pageController = PageController();
  int startIndex = 0;
  bool _isSaving = false;

  final List<OnboardingItem> onboardingItems = const [
    OnboardingItem(
      image: 'image_one.png',
      title: 'Suivez facilement vos finances.',
      description:
          'Connectez vos comptes bancaires en toute sécurité et suivez vos revenus, dépenses et soldes en temps réel, tout-en-un seul endroit.',
    ),
    OnboardingItem(
      image: 'image_two.png',
      title: 'Atteignez vos objectifs financiers.',
      description:
          'Définissez vos objectifs (achat, épargne, investissement) et laissez l\'application vous guider avec des plans personnalisés pour les atteindre plus rapidement.',
    ),
    OnboardingItem(
      image: 'image_three.png',
      title: 'Recevez des conseils intelligents.',
      description:
          'L\'application analyse vos habitudes financières et vous propose des recommandations pour économiser, mieux gérer votre budget et optimiser vos dépenses.',
    ),
  ];

  bool get _isLastPage => startIndex == onboardingItems.length - 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToNextPage() async {
    if (_isLastPage) {
      await _completeOnboarding();
      return;
    }
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _completeOnboarding() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (!mounted) return;

    await widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withOpacity(0.08),
              Colors.white,
              const Color(0xFFEAF6FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (!_isLastPage)
                      onbordingBtn(
                        label: 'Passer',
                        type: OnboardingButtonType.ghost,
                        onPressed: () {
                          _pageController.animateToPage(
                            onboardingItems.length - 1,
                            duration: const Duration(milliseconds: 360),
                            curve: Curves.easeOut,
                          );
                        },
                      ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingItems.length,
                  onPageChanged: (currentIndex) {
                    setState(() {
                      startIndex = currentIndex;
                    });
                  },
                  itemBuilder: (context, index) {
                    final item = onboardingItems[index];
                    return onboard(item.image, item.title, item.description);
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(onboardingItems.length, (index) {
                    final selected = index == startIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      width: selected ? 24 : 9,
                      height: 9,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: selected
                            ? colorScheme.primary
                            : colorScheme.primary.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (startIndex > 0)
                      onbordingBtn(
                        label: 'Précédent',
                        type: OnboardingButtonType.ghost,
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeOutCubic,
                          );
                        },
                      )
                    else
                      const SizedBox(width: 95),
                    onbordingBtn(
                      label: _isLastPage ? 'C\'est parti !' : 'Suivant',
                      type: OnboardingButtonType.primary,
                      isLoading: _isSaving,
                      onPressed: _goToNextPage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingItem {
  final String image;
  final String title;
  final String description;

  const OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
  });
}
