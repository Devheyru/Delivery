import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle onboardingTextStyle() {
    return const TextStyle(
      color: Color(0xbef59e0b),
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle leadingTextStyle() {
    return const TextStyle(
      color: Color(0xFF3C2F2F),
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle detailsTitleText() {
    return const TextStyle(
      color: Color(0xFF3C2F2F),
      fontSize: 26,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle totalPriceTextStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    );
  }

  static TextStyle simpleOnboardingTextStyle() {
    return const TextStyle(
      color: Color(0xFF6A6A6A),
      fontSize: 16,
      fontFamily: "roboto",
      overflow: TextOverflow.fade,
    );
  }

  static TextStyle priceTextStyle() {
    return const TextStyle(
      color: Color(0xFF6A6A6A),
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle signUpTextStyle() {
    return const TextStyle(
      color: Color(0xFF6A6A6A),
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle whiteBoldTextFieldStyle() {
    return const TextStyle(
      color: Color(0xffffffff),
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
  }
}
