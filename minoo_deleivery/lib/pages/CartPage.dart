import 'package:flutter/material.dart';
import 'package:minoo_deleivery/pages/home.dart';

class Cartpage extends StatefulWidget {
  const Cartpage({super.key});

  @override
  State<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends State<Cartpage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final int count = 4;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 30),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const Home()),
                          (_) => false,
                        );
                      },
                    ),
                    const Text("Cart", style: TextStyle(fontSize: 24)),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "done",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xfff59e0b),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Cart Items List
              SizedBox(
                height: size.height / 2.1,

                child: ListView.builder(
                  itemCount: count, // Replace with cartItems.length
                  padding: const EdgeInsets.all(16),

                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border:
                            count > 1
                                ? const Border(
                                  top: BorderSide(color: Colors.lightBlue),
                                  left: BorderSide(color: Colors.lightBlue),
                                  right: BorderSide(color: Colors.lightBlue),
                                )
                                : const Border(
                                  top: BorderSide(color: Colors.lightBlue),
                                  bottom: BorderSide(color: Colors.lightBlue),
                                  left: BorderSide(color: Colors.lightBlue),
                                  right: BorderSide(color: Colors.lightBlue),
                                ),
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image
                          Container(
                            padding: const EdgeInsets.all(5),

                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.asset(
                              "assets/images/Cheeseburger.png",
                              height: 120,
                              width: 120,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 20),

                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Chees Burger",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text("HumBurger"),
                                      ],
                                    ),
                                    const Spacer(),
                                    _iconButton(
                                      icon: Icons.delete,
                                      color: const Color(0xFFf53e0b),
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 50),
                                Row(
                                  children: [
                                    const Text(
                                      "65 birr",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 30),
                                    Row(
                                      children: [
                                        _iconButton(
                                          icon: Icons.add,
                                          color: const Color(0xFFf59e0b),
                                          onTap: () => setState(() {}),
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          "1",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(width: 10),
                                        _iconButton(
                                          icon: Icons.remove,
                                          color: const Color(0xFFf59e0b),
                                          onTap: () {},
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // Bottom Summary Section
          Positioned(
            bottom: -25,
            child: Material(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              elevation: 5.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                width: size.width,
                height: size.height / 2.65,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(222, 39, 38, 38),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "DELIVERY ADDRESS",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        TextButton(
                          style: ButtonStyle(
                            overlayColor: WidgetStateProperty.all(
                              const Color.fromARGB(255, 22, 94, 22),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Edit",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.green,
                              color: Colors.green,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      width: double.infinity,
                      height: 80,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 115, 147, 162),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "1000 Addis Ababa Bole Road",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Row(
                          children: [
                            const Row(
                              children: [
                                Text(
                                  "Total: ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  "96 ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                  ),
                                ),
                                Text(
                                  " Birr",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      width: MediaQuery.of(context).size.width / 1.5,
                      height: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFf58e0b),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Place Order",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 24, color: Colors.white),
        ),
      ),
    );
  }
}
