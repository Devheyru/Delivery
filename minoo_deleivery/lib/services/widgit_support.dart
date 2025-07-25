import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppWidget {
  static TextStyle OnboardingTextStyle() {
    return const TextStyle(
      color: Color(0xbef59e0b),
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle LeadingTextStyle() {
    return const TextStyle(
      color: Color(0xFF3C2F2F),
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle TotalPriceTextStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    );
  }

  static TextStyle SimpleOnboardingTextStyle() {
    return const TextStyle(
      color: Color(0xFF6A6A6A),
      fontSize: 16,
      fontFamily: "roboto",
      overflow: TextOverflow.fade,
    );
  }

  static TextStyle PriceTextStyle() {
    return const TextStyle(
      color: Color(0xFF6A6A6A),
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle PrimaryStyle() {
    return const TextStyle(color: Color(0xfff59e0b), fontSize: 16);
  }

  static TextStyle WhiteTextFieldStyle() {
    return const TextStyle(
      color: Color(0xffffffff),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle RecomendedFoodStyle() {
    return const TextStyle(
      color: Color(0xFF3C2F2F),
      fontFamily: 'roboto',
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }
}
