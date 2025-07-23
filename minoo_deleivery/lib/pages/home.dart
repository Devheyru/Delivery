import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minoo_deleivery/pages/order.dart';
import 'package:minoo_deleivery/pages/profile.dart';
import 'package:minoo_deleivery/pages/wallet.dart';
import 'package:minoo_deleivery/services/widgit_support.dart';
import 'package:minoo_deleivery/utils/food_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //this is for bottom nav bar
  late List<Widget> pages;
  late Home HomePage;
  late Order order;
  late Wallet wallet;
  late Profile profile;

  int currentTabIndex = 0;

  @override
  void initState() {
    HomePage = Home();
    order = Order();
    wallet = Wallet();
    profile = Profile();

    pages = [HomePage, order, wallet, profile];
    super.initState();
  }

  //this is for search
  String _searchQuery = '';

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          items: [
            Icon(Icons.home, size: 30, color: Colors.white),
            Icon(Icons.shopping_bag, size: 30, color: Colors.white),
            Icon(Icons.wallet, size: 30, color: Colors.white),
            Icon(Icons.person, size: 30, color: Colors.white),
          ],
          height: MediaQuery.of(context).size.height * 0.065,
          backgroundColor: Colors.white,
          color: Color(0xFFf59e0b),
          animationDuration: Duration(milliseconds: 300),
          onTap: (int index) => setState(() => currentTabIndex = index),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 5, left: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MINOO",
                            style: TextStyle(
                              color: Color(0xfff59e0b),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Order your favorite food!",
                            style: AppWidget.SimpleOnboardingTextStyle(),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            "assets/images/abushe.jpg",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
                          margin: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Color(0xffececf9),
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: TextField(
                            onChanged: _onSearchChanged,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search your favorite...",
                              helperStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xfff59e0b),
                        ),
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                    ],
                  ),
                  //product filter from other file
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: FoodScreen(searchQuery: _searchQuery),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
