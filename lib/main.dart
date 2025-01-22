import 'package:flutter/material.dart';
import 'package:smarth_save/PlaidLogin.dart';
import 'package:smarth_save/screen/onbording.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SmartSave',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const OnbordingPage());
    // home: const PlaidLogin());
  }
}
