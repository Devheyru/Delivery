import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minoo_deleivery/config/firebase_options.dart';
import 'package:minoo_deleivery/pages/CartPage.dart';
import 'package:minoo_deleivery/pages/forgot_password.dart';
import 'package:minoo_deleivery/pages/home.dart';
import 'package:minoo_deleivery/pages/login.dart';
import 'package:minoo_deleivery/pages/onboarding.dart';
import 'package:minoo_deleivery/pages/order_history.dart';
import 'package:minoo_deleivery/pages/profile.dart';
import 'package:minoo_deleivery/pages/signUp.dart';
import 'package:minoo_deleivery/pages/wallet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint('Firebase initialization notice: $e');
  }

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: 'Minoo Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xfff53e0b)),
        useMaterial3: true,
        primaryColor: const Color(0xfff53e0b),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Onboarding(),
        '/home': (context) => const Home(),
        '/cart': (context) => const Cartpage(),
        '/orders': (context) => const OrderHistoryPage(),
        '/login': (context) => const Login(),
        '/logIn': (context) => const Login(),
        '/signup': (context) => const Signup(),
        '/signUp': (context) => const Signup(),
        '/wallet': (context) => const Wallet(),
        '/profile': (context) => const ProfilePage(),
        '/forgotPassword': (context) => const ForgotPassword(),
        '/forgot-password': (context) => const ForgotPassword(),
      },
    );
  }
}
