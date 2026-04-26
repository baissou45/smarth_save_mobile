import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:smarth_save/config/router.dart';
import 'package:smarth_save/providers/userProvider.dart';
import 'package:smarth_save/providers/transactionProvider.dart';
import 'package:smarth_save/providers/categorie_provider.dart';
import 'package:smarth_save/providers/projet_provider.dart';
import 'package:smarth_save/providers/account_provider.dart';
import 'package:smarth_save/providers/money_visibility_provider.dart';
import 'package:smarth_save/services/dio_client.dart';

// Global instances
final transactionProvider = Transactionprovider();
final categorieProvider = CategorieProvider();
final projetProvider = ProjetProvider();
final accountProvider = AccountProvider();
final moneyVisibilityProvider = MoneyVisibilityProvider();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize date formatting for French locale
  await initializeDateFormatting('fr_FR', null);

  final userProvider = UserProvider();
  await userProvider.loadToken();

  // Register 401 handler with DioClient for automatic logout
  DioClient.setUnauthorizedHandler((message) {
    // Clear user provider and navigate to login
    userProvider.logout();
    Future.microtask(() {
      router.go('/login');
      final context = rootNavigatorKey.currentContext;
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });
  });

  // Initialize money visibility provider
  await moneyVisibilityProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: userProvider),
        ChangeNotifierProvider.value(value: transactionProvider),
        ChangeNotifierProvider.value(value: categorieProvider),
        ChangeNotifierProvider.value(value: projetProvider),
        ChangeNotifierProvider.value(value: accountProvider),
        ChangeNotifierProvider.value(value: moneyVisibilityProvider),
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