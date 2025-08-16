import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minoo_deleivery/pages/CartPage.dart';
import 'package:minoo_deleivery/pages/home.dart';
import 'package:minoo_deleivery/pages/login.dart';
import 'package:minoo_deleivery/pages/onboarding.dart';
import 'package:minoo_deleivery/pages/signUp.dart';
import 'package:minoo_deleivery/pages/wallet.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
      initialRoute: '/',
      routes: {
        '/': (context) => const Onboarding(),
        '/home': (context) => const Home(),
        '/cart': (context) => const Cartpage(),
        '/logIn': (context) => const Login(),
        '/signUp': (context) => const Signup(),
        '/wallet': (context) => const Wallet(),
      },
    );
  }
}
