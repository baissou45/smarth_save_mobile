import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/providers/userProvider.dart';
import 'package:smarth_save/screen/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 🔥 Création de l'instance unique de UserProvider
  final userProvider = UserProvider();
  await userProvider
      .loadToken(); // Charge le token avant d'afficher l'application

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: userProvider, // 🔥 Utilisation de la même instance !
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) { 
    final userProvider = Provider.of<UserProvider>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SmartSave',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen()
       );
  }
}
