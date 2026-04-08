import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/config/router.dart';
import 'package:smarth_save/providers/userProvider.dart';
import 'package:smarth_save/providers/transactionProvider.dart';
import 'package:smarth_save/providers/categorie_provider.dart';
import 'package:smarth_save/providers/projet_provider.dart';

// Global instances
final transactionProvider = Transactionprovider();
final categorieProvider = CategorieProvider();
final projetProvider = ProjetProvider();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final userProvider = UserProvider();
  await userProvider.loadToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: userProvider),
        ChangeNotifierProvider.value(value: transactionProvider),
        ChangeNotifierProvider.value(value: categorieProvider),
        ChangeNotifierProvider.value(value: projetProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SmartSave',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}