import 'package:flutter/material.dart';
import 'package:smarth_save/core/utils/theme/colors.dart';
import 'package:smarth_save/models/user_model.dart';
import 'package:smarth_save/widgets/naveBar.dart';
import 'package:go_router/go_router.dart';

class Wellcommepage extends StatefulWidget {
  const Wellcommepage({super.key});

  @override
  State<Wellcommepage> createState() => _WellcommepageState();
}

class _WellcommepageState extends State<Wellcommepage> {
  var montant = "1095,02";
  @override
  Widget build(BuildContext context) {
    double largeur = MediaQuery.of(context).size.width;
    double hauteur = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor1,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bienvenue",
              style: TextStyle(
                  fontSize: largeur / 30,
                  color: Colors.white,
                  fontWeight: FontWeight.normal),
            ),
            Text(
              "${UserModel.sessionUser?.prenom ?? ""} ${UserModel.sessionUser?.nom ?? ""}",
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
                      color: Colors.black26, // Couleur de l'ombre
                      blurRadius: 10, // Flou de l'ombre
                      spreadRadius: 2, // Expansion de l'ombre
                      offset: Offset(4, 4), // Décalage de l'ombre
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30, // Ajuste la taille
                  child: Icon(Icons
                      .notifications_active_outlined), // Utilisation directe du widget SVG ou icône
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
      body: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Container vert (background)
                Container(
                  color: kPrimaryColor1,
                  height: hauteur / 5,
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: largeur / 20),
                      Text(
                        "${montant.split("").join("")} €",
                        style: TextStyle(
                          fontSize: largeur / 10,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: hauteur / 60),
                      Text(
                        "Solde",
                        style: TextStyle(
                            fontSize: largeur / 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                // Conteneur pour le reste
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(8, 8),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.only(
                      top: hauteur / 5 - 30, left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Mes banques",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            left: largeur / 5, top: 4, bottom: 10),
                        height: 4,
                        width: largeur / 8,
                        decoration: BoxDecoration(
                          color: kPrimaryColor1,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(
                        height: hauteur / 10.5,
                        child: PageView(
                          controller: PageController(viewportFraction: 0.85),
                          children: [
                            _BankCardStyled(
                              bankName: 'BNP Paris Bas',
                              logoPath: 'assets/images/bnp.jpg',
                              balance: '1 095,02 €',
                              bgGradient: [kPrimaryColor1, kPrimaryColor2],
                            ),
                            _BankCardStyled(
                              bankName: 'Société Générale',
                              logoPath: 'assets/images/sg.png',
                              balance: '2 300,00 €',
                              bgGradient: [
                                Colors.deepPurple,
                                Colors.purpleAccent
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Section raccourcis
                      Text(
                        "Raccourcis",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor1,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ShortcutButton(
                            icon: Icons.add,
                            label: 'Ajouter',
                            gradient: [kPrimaryColor1, kPrimaryColor2],
                          ),
                          _ShortcutButton(
                            icon: Icons.swap_horiz,
                            label: 'Transférer',
                            gradient: [Colors.deepPurple, Colors.purpleAccent],
                          ),
                          _ShortcutButton(
                            icon: Icons.history,
                            label: 'Historique',
                            gradient: [Colors.orange, Colors.deepOrangeAccent],
                          ),
                          _ShortcutButton(
                            icon: Icons.person,
                            label: 'Profil',
                            gradient: [Colors.teal, Colors.cyan],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Section activité récente
                      Text(
                        "Activité récente",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor1,
                        ),
                      ),
                      SizedBox(height: 10),
                      ..._recentActivities(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
      margin: EdgeInsets.only(right: 8),
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
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: Image.asset(logoPath).image,
            radius: 26,
            backgroundColor: Colors.white,
          ),
          SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(bankName,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17)),
                Text(balance,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortcutButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  const _ShortcutButton(
      {required this.icon, required this.label, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Column(
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
                offset: Offset(2, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        SizedBox(height: 6),
        Text(label,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

List<Widget> _recentActivities() {
  // À personnaliser avec des vraies données
  final activities = [
    {
      "title": "Paiement carte",
      "date": "27 mai",
      "amount": "-12,99€",
      "color": Colors.redAccent
    },
    {
      "title": "Virement reçu",
      "date": "26 mai",
      "amount": "+150,00€",
      "color": Colors.green
    },
    {
      "title": "Retrait DAB",
      "date": "25 mai",
      "amount": "-40,00€",
      "color": Colors.redAccent
    },
  ];
  return activities
      .map((a) => Card(
            margin: EdgeInsets.symmetric(vertical: 4),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: (a["color"] as Color).withOpacity(0.15),
                child: Icon(
                  a["amount"].toString().startsWith("-")
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  color: a["color"] as Color,
                ),
              ),
              title: Text(a["title"] as String,
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(a["date"] as String),
              trailing: Text(a["amount"] as String,
                  style: TextStyle(
                      color: a["color"] as Color, fontWeight: FontWeight.bold)),
            ),
          ))
      .toList();
}
