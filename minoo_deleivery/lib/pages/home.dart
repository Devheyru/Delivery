import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:minoo_deleivery/pages/CartPage.dart';
import 'package:minoo_deleivery/pages/favoriteItems.dart';
import 'package:minoo_deleivery/pages/login.dart';
import 'package:minoo_deleivery/pages/mainHomeComponents.dart';
import 'package:minoo_deleivery/pages/wallet.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTabIndex = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const HomeContent(),
      const Favoriteitems(),
      const Wallet(),
      const Cartpage(),
      const Login(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        index: currentTabIndex,
        items: const [
          Icon(Icons.home, size: 24, color: Colors.white),
          Icon(Icons.favorite, size: 24, color: Colors.white),
          Icon(Icons.wallet, size: 24, color: Colors.white),
          Icon(Icons.shopping_cart, size: 24, color: Colors.white),
        ],
        height: MediaQuery.of(context).size.height * 0.065,
        backgroundColor: Colors.white,
        color: const Color(0xFFf59e0b),
        animationDuration: const Duration(milliseconds: 300),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
      ),
      body: SafeArea(child: pages[currentTabIndex]),
    );
  }
}
