import 'package:flutter/material.dart';
import 'package:minoo_deleivery/services/widgit_support.dart';
import 'package:minoo_deleivery/pages/home.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  late final Widget homePage; // preload instance

  @override
  void initState() {
    super.initState();
    homePage = const Home();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Image.asset('assets/images/onboard.png'),
            const SizedBox(height: 20),
            Text(
              "The fastest\nFood Delivery!",
              textAlign: TextAlign.center,
              style: AppWidget.onboardingTextStyle(),
            ),
            const SizedBox(height: 20.0),
            Text(
              "Order your favorite food from\nyour favorite restaurants and\nhave it delivered to your \ndoorstep.",
              textAlign: TextAlign.center,
              style: AppWidget.simpleOnboardingTextStyle(),
            ),
            const SizedBox(height: 30.0),

            // Button
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width / 2,
              decoration: BoxDecoration(
                color: const Color(0xfff59e0b),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => homePage),
                    );
                  },
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
