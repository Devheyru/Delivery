import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minoo_deleivery/services/auth/auth_service.dart';
import 'package:minoo_deleivery/utils/food_screen.dart';

class HomeContent extends StatefulWidget {
  final VoidCallback? onProfileTap;

  const HomeContent({super.key, this.onProfileTap});

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

                        // Real User Avatar
                        StreamBuilder<User?>(
                          stream: AuthService.authStateChanges,
                          builder: (context, authSnapshot) {
                            final user = authSnapshot.data;
                            if (user != null) {
                              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                stream: AuthService.userStream(user.uid),
                                builder: (context, userSnapshot) {
                                  final userData = userSnapshot.data?.data();
                                  final name = userData?['name'] ?? user.displayName ?? 'Customer';
                                  final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'U';
                                  final String? photoUrl = userData?['photoUrl'] ?? user.photoURL;

                                  return GestureDetector(
                                    onTap: () {
                                      if (widget.onProfileTap != null) {
                                        widget.onProfileTap!();
                                      } else {
                                        Navigator.pushNamed(context, '/profile');
                                      }
                                    },
                                    child: Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [Color(0xfff59e0b), Color(0xffd97706)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xfff59e0b).withValues(alpha: 0.35),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: (photoUrl != null && photoUrl.trim().isNotEmpty)
                                          ? ClipOval(
                                              child: Image.network(
                                                photoUrl,
                                                width: 48,
                                                height: 48,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) => Text(
                                                  initial,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 22,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Text(
                                              initial,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22,
                                              ),
                                            ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  if (widget.onProfileTap != null) {
                                    widget.onProfileTap!();
                                  } else {
                                    Navigator.pushNamed(context, '/login');
                                  }
                                },
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFececf8),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xfff59e0b), width: 1.8),
                                  ),
                                  child: const Icon(
                                    Icons.person_outline_rounded,
                                    color: Color(0xfff59e0b),
                                    size: 26,
                                  ),
                                ),
                              );
                            }
                          },
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
