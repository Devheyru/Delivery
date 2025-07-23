import 'package:flutter/material.dart';
import 'package:minoo_deleivery/pages/details.dart';
import 'package:minoo_deleivery/pages/home.dart';
import 'package:minoo_deleivery/pages/onboarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minoo Deleivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xfff53e0b)),
      ),
      routes: {'/home': (context) => const Home()},
      home: const Onboarding(),
    );
  }
}
