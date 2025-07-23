import 'package:flutter/material.dart';
import 'package:minoo_deleivery/services/widgit_support.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Image.asset('assets/images/onboard.png'),
            const SizedBox(height: 20),
            Text(
              textAlign: TextAlign.center,
              "The fastest\nFood Delivery!",
              style: AppWidget.OnboardingTextStyle(),
            ),
            const SizedBox(height: 20.0),
            Text(
              textAlign: TextAlign.center,
              "Order your favorite food from\nyour favorite restaurants and\nhave it delivered to your \ndoorstep.",
              style: AppWidget.SimpleOnboardingTextStyle(),
            ),

            const SizedBox(height: 30.0),
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
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Text(
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
