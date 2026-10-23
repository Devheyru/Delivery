import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minoo_deleivery/pages/CartPage.dart';
import 'package:minoo_deleivery/pages/favoriteItems.dart';
import 'package:minoo_deleivery/pages/login.dart';
import 'package:minoo_deleivery/pages/mainHomeComponents.dart';
import 'package:minoo_deleivery/pages/order_history.dart';
import 'package:minoo_deleivery/pages/profile.dart';
import 'package:minoo_deleivery/services/auth/auth_service.dart';

class Home extends StatefulWidget {
  final int initialIndex;

  const Home({super.key, this.initialIndex = 0});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int currentTabIndex;

  @override
  void initState() {
    super.initState();
    currentTabIndex = widget.initialIndex;
  }

  Widget _buildTabBody(User? user) {
    switch (currentTabIndex) {
      case 0:
        return HomeContent(
          onProfileTap: () {
            setState(() => currentTabIndex = 4);
          },
        );
      case 1:
        return const Favoriteitems();
      case 2:
        return const OrderHistoryPage();
      case 3:
        return const Cartpage();
      case 4:
      default:
        return user != null
            ? ProfilePage(
                onLogOut: () {
                  setState(() => currentTabIndex = 4);
                },
              )
            : const Login();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges,
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: CurvedNavigationBar(
            index: currentTabIndex,
            items: const [
              Icon(Icons.home, size: 24, color: Colors.white),
              Icon(Icons.favorite, size: 24, color: Colors.white),
              Icon(Icons.receipt_long, size: 24, color: Colors.white),
              Icon(Icons.shopping_cart, size: 24, color: Colors.white),
              Icon(Icons.person, size: 24, color: Colors.white),
            ],
            height: (MediaQuery.of(context).size.height * 0.065).clamp(50.0, 75.0),
            backgroundColor: Colors.white,
            color: const Color(0xFFf59e0b),
            animationDuration: const Duration(milliseconds: 300),
            onTap: (int index) {
              setState(() {
                currentTabIndex = index;
              });
            },
          ),
          body: SafeArea(child: _buildTabBody(user)),
        );
      },
    );
  }
}
