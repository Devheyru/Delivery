import 'package:flutter/material.dart';
import 'package:minoo_deleivery/utils/food_screen.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _searchQuery = '';

  void _onSearchChanged(String value) {
    setState(() => _searchQuery = value);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
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
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.receipt_long, color: Color(0xfff59e0b), size: 30),
                          tooltip: 'My Orders',
                          onPressed: () => Navigator.pushNamed(context, '/orders'),
                        ),
                        const SizedBox(width: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/signUp'),
                            child: Image.asset(
                              "assets/images/abushe.jpg",
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 20),
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xffececf9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        onChanged: _onSearchChanged,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search your favorite...",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xfff59e0b),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.only(left: 16),
              child: FoodScreen(searchQuery: _searchQuery),
            ),
          ],
        ),
      ),
    );
  }
}
