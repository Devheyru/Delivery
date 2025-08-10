import "package:flutter/material.dart";
import 'package:minoo_deleivery/pages/home.dart';
import 'package:minoo_deleivery/pages/login.dart';
import 'package:minoo_deleivery/pages/onboarding.dart';
import 'package:minoo_deleivery/pages/signUp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minoo Deleivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xfff53e0b)),
        useMaterial3: true,
        primaryColor: Color(0xfff53e0b),
      ),
      routes: {'/home': (context) => const Home()},
      home: const Onboarding(),
    );
  }
}
