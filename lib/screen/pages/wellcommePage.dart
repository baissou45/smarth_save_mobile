import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/widgets/naveBar.dart';

class Wellcommepage extends StatefulWidget {
  const Wellcommepage({super.key});

  @override
  State<Wellcommepage> createState() => _WellcommepageState();
}

class _WellcommepageState extends State<Wellcommepage> {
  final String _montant = '1 095,02';
  late final PageController _bankController;
  int _currentBankIndex = 0;

  final List<_BankData> _banks = const [
    _BankData(
      name: 'BNP Paribas',
      logoPath: 'assets/images/bnp.jpg',
      balance: '1 095,02 €',
      gradient: [Color(0xFF0E9F6E), Color(0xFF117A8B)],
    ),
    _BankData(
      name: 'Société Générale',
      logoPath: 'assets/images/sg.png',
      balance: '2 300,00 €',
      gradient: [Color(0xFF0B5ED7), Color(0xFF1F9CF0)],
    ),
  ];

  final List<_ShortcutData> _shortcuts = const [
    _ShortcutData(
      icon: Icons.add,
      label: 'Ajouter',
      gradient: [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
      link: '/creatProjet',
    ),
    _ShortcutData(
      icon: Icons.swap_horiz,
      label: 'Transférer',
      gradient: [Color(0xFF10B981), Color(0xFF0EA5A4)],
      link: '/creatTransaction',
    ),
    _ShortcutData(
      icon: Icons.history,
      label: 'Historique',
      gradient: [Color(0xFFF59E0B), Color(0xFFEF4444)],
      link: '/transation',
    ),
    _ShortcutData(
      icon: Icons.person,
      label: 'Profil',
      gradient: [Color(0xFFEC4899), Color(0xFFF97316)],
      link: '/modifProfile',
    ),
  ];

  final List<_ActivityData> _activities = const [
    _ActivityData(
      title: 'Paiement carte',
      date: '27 mai',
      amount: '-12,99€',
      color: Colors.redAccent,
    ),
    _ActivityData(
      title: 'Virement reçu',
      date: '26 mai',
      amount: '+150,00€',
      color: Colors.green,
    ),
    _ActivityData(
      title: 'Retrait DAB',
      date: '25 mai',
      amount: '-40,00€',
      color: Colors.redAccent,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bankController = PageController(viewportFraction: 0.88);
    _bankController.addListener(() {
      final page = _bankController.page?.round() ?? 0;
      if (page != _currentBankIndex && mounted) {
        setState(() {
          _currentBankIndex = page;
        });
      }
    });
  }

  @override
  void dispose() {
    _bankController.dispose();
    super.dispose();
  }

  String get _fullName {
    final prenom = UserModel.sessionUser?.prenom ?? '';
    final nom = UserModel.sessionUser?.nom ?? '';
    final fullName = '$prenom $nom'.trim();
    return fullName.isEmpty ? 'Utilisateur' : fullName;
  }

  @override
  Widget build(BuildContext context) {
    final largeur = MediaQuery.of(context).size.width;
    final hauteur = MediaQuery.of(context).size.height;
    final cardHeight = (hauteur * 0.16).clamp(120.0, 170.0).toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor1,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue',
              style: TextStyle(
                  fontSize: largeur / 30 > 14 ? 14 : largeur / 30,
                  color: Colors.white,
                  fontWeight: FontWeight.normal),
            ),
            Text(
              _fullName,
              style: TextStyle(fontSize: largeur / 20, color: Colors.white),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                GoRouter.of(context).push('/notification');
              },
              icon: Container(
                width: 45,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(Icons.notifications_active_outlined),
                ),
              )),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ],
      ),
      drawer: Navebar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: hauteur * 0.24,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kPrimaryColor1, kPrimaryColor2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Solde total',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_montant €',
                        style: TextStyle(
                          fontSize: largeur / 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  top: hauteur * 0.24 - 30,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    // padding: const EdgeInsets.symmetric(
                    //     horizontal: 16, vertical: 14),
                    // child: Row(
                    //   children: [
                    //     Container(
                    //       width: 44,
                    //       height: 44,
                    //       decoration: BoxDecoration(
                    //         color: kPrimaryColor1.withOpacity(0.12),
                    //         borderRadius: BorderRadius.circular(12),
                    //       ),
                    //       child:
                    //           Icon(Icons.wallet_rounded, color: kPrimaryColor1),
                    //     ),
                    //     const SizedBox(width: 12),
                    //     const Expanded(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: const [
                    //           Text(
                    //             'Budget du mois',
                    //             style: TextStyle(
                    //               fontWeight: FontWeight.w700,
                    //               fontSize: 14,
                    //             ),
                    //           ),
                    //           SizedBox(height: 2),
                    //           Text(
                    //             'Vous gérez bien vos finances',
                    //             style: TextStyle(
                    //               color: Colors.black54,
                    //               fontSize: 12,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),

                    //     Icon(Icons.chevron_right_rounded,
                    //         color: kPrimaryColor1),
                    //   ],
                    // ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                top: 34,
                left: largeur * 0.04,
                right: largeur * 0.04,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle(title: 'Mes banques'),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: cardHeight,
                    child: PageView.builder(
                      controller: _bankController,
                      itemCount: _banks.length,
                      itemBuilder: (context, index) {
                        final bank = _banks[index];
                        return _BankCardStyled(
                          bankName: bank.name,
                          logoPath: bank.logoPath,
                          balance: bank.balance,
                          bgGradient: bank.gradient,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_banks.length, (index) {
                      final isActive = index == _currentBankIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: isActive ? 18 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isActive ? kPrimaryColor1 : Colors.black26,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Raccourcis'),
                  const SizedBox(height: 12),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 14,
                    runSpacing: 12,
                    children: _shortcuts
                        .map(
                          (shortcut) => _ShortcutButton(
                            icon: shortcut.icon,
                            label: shortcut.label,
                            gradient: shortcut.gradient,
                            link: shortcut.link,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Activité récente'),
                  const SizedBox(height: 10),
                  ..._activities
                      .map((activity) => _ActivityTile(activity: activity))
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: kPrimaryColor1,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 4,
          width: 44,
          decoration: BoxDecoration(
            color: kPrimaryColor1,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}

class _BankCardStyled extends StatelessWidget {
  final String bankName;
  final String logoPath;
  final String balance;
  final List<Color> bgGradient;
  const _BankCardStyled({
    required this.bankName,
    required this.logoPath,
    required this.balance,
    required this.bgGradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: bgGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: bgGradient.first.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: Image.asset(logoPath).image,
            radius: 26,
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  bankName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                Text(
                  balance,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class _ShortcutButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final List<Color> gradient;
//   final String link;

//   const _ShortcutButton(
//       {required this.icon, required this.label, required this.gradient, required this.link});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
      
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 54,
//           height: 54,
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: gradient,
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             shape: BoxShape.circle,
//             boxShadow: [
//               BoxShadow(
//                 color: gradient.first.withOpacity(0.22),
//                 blurRadius: 6,
//                 offset: const Offset(2, 4),
//               ),
//             ],
//           ),
//           child: Icon(icon, color: Colors.white, size: 28),
//         ),
//         const SizedBox(height: 6),
//         Text(
//           label,
//           style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
//         ),
//       ],
//     );
//   }
// }


class _ShortcutButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final String link;

  const _ShortcutButton({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Clicked: $link");
        // Navigator.pushNamed(context, link); // si navigation
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: gradient.first.withOpacity(0.22),
                  blurRadius: 6,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final _ActivityData activity;
  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: activity.color.withOpacity(0.15),
          child: Icon(
            activity.amount.startsWith('-')
                ? Icons.arrow_downward_rounded
                : Icons.arrow_upward_rounded,
            color: activity.color,
          ),
        ),
        title: Text(
          activity.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(activity.date),
        trailing: Text(
          activity.amount,
          style: TextStyle(color: activity.color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _BankData {
  final String name;
  final String logoPath;
  final String balance;
  final List<Color> gradient;

  const _BankData({
    required this.name,
    required this.logoPath,
    required this.balance,
    required this.gradient,
  });
}

class _ShortcutData {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final String link;

  const _ShortcutData({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.link,
  });
}

class _ActivityData {
  final String title;
  final String date;
  final String amount;
  final Color color;

  const _ActivityData({
    required this.title,
    required this.date,
    required this.amount,
    required this.color,
  });
}
