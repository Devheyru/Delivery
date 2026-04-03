import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minoo_deleivery/pages/PriceDetails.dart';
import 'package:minoo_deleivery/pages/addressPage.dart';
import 'package:minoo_deleivery/pages/home.dart';
import 'package:minoo_deleivery/providers/address/address_providers.dart';
import 'package:minoo_deleivery/providers/menu/cart_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Cartpage extends ConsumerStatefulWidget {
  const Cartpage({super.key});

  @override
  ConsumerState<Cartpage> createState() => _CartpageState();
}

class _CartpageState extends ConsumerState<Cartpage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cartItems = ref.watch(cartProvider); // <-- watch cart
    final selectedAddress = ref.watch(selectedCenterProvider);
    final selectedDestination = ref.watch(selectedDestinationProvider);
    final totalPrice = ref.watch(totalPriceProvider);

    return Scaffold(
      backgroundColor: Colors.white,
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
                          MaterialPageRoute(builder: (_) => Home()),
                          (route) => false,
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
                height: 413,
                child:
                    cartItems.isEmpty
                        ? const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            'Your cart is empty',
                            style: TextStyle(fontSize: 30),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = cartItems[index];
                            final food = cartItem.food;

                            return Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border:
                                    cartItems.length > 1
                                        ? const Border(
                                          top: BorderSide(
                                            color: Colors.lightBlue,
                                          ),
                                          left: BorderSide(
                                            color: Colors.lightBlue,
                                          ),
                                          right: BorderSide(
                                            color: Colors.lightBlue,
                                          ),
                                        )
                                        : const Border(
                                          top: BorderSide(
                                            color: Colors.lightBlue,
                                          ),
                                          bottom: BorderSide(
                                            color: Colors.lightBlue,
                                          ),
                                          left: BorderSide(
                                            color: Colors.lightBlue,
                                          ),
                                          right: BorderSide(
                                            color: Colors.lightBlue,
                                          ),
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
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: CachedNetworkImage(
                                        imageUrl: food.imageUrl,
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (context, url) => const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                        errorWidget:
                                            (context, url, error) =>
                                                Text(error.toString()),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  // Product Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              // <-- Wrap this Column or just the Text
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    food.menuName,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                    ),
                                                    maxLines:
                                                        2, // optional: limit max lines
                                                    overflow:
                                                        TextOverflow
                                                            .ellipsis, // optional: show ... if too long
                                                  ),
                                                  Text(food.menuCategory ?? ''),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            _iconButton(
                                              icon: Icons.delete,
                                              color: const Color(0xFFf53e0b),
                                              onTap: () {
                                                ref
                                                    .read(cartProvider.notifier)
                                                    .removeItem(food);
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 25),
                                        Row(
                                          children: [
                                            Text(
                                              //commented to hide the price
                                              // '${(food.menuPrice * cartItem.quantity).toStringAsFixed(0)} birr',
                                              '',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Spacer(),
                                            Row(
                                              children: [
                                                _iconButton(
                                                  icon: Icons.remove,
                                                  color: const Color(
                                                    0xFFf59e0b,
                                                  ),
                                                  onTap: () {
                                                    if (cartItem.quantity > 1) {
                                                      final newQty =
                                                          cartItem.quantity - 1;
                                                      ref
                                                          .read(
                                                            cartProvider
                                                                .notifier,
                                                          )
                                                          .updateQuantity(
                                                            food,
                                                            newQty,
                                                          );
                                                    }
                                                  },
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  '${cartItem.quantity}',
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                _iconButton(
                                                  icon: Icons.add,
                                                  color: const Color(
                                                    0xFFf59e0b,
                                                  ),
                                                  onTap: () {
                                                    if (cartItem.quantity <
                                                        10) {
                                                      final newQty =
                                                          cartItem.quantity + 1;
                                                      ref
                                                          .read(
                                                            cartProvider
                                                                .notifier,
                                                          )
                                                          .updateQuantity(
                                                            food,
                                                            newQty,
                                                          );
                                                    }
                                                  },
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

          // Bottom Summary Section (update total price)
          Positioned(
            bottom: -25,
            child: Material(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              elevation: 5.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Addresspage(),
                              ),
                            );
                          },
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
                        (selectedAddress == null || selectedDestination == null)
                            ? "Select Delivery Center and Destination"
                            : "${selectedAddress.name}. to \n${selectedDestination.name}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Total:",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              totalPrice.toStringAsFixed(0),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                              ),
                            ),
                            const Text(
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
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      width: size.width / 1.5,
                      height: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFf58e0b),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (cartItems.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Cart Empty"),
                                  content: const Text(
                                    "You have no items in your cart.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (selectedDestination == null &&
                              selectedAddress == null) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Address not Selected"),
                                  content: const Text(
                                    "Select Delivery center and Destination",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutSummaryPage(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Place Order",
                          style: TextStyle(color: Colors.white, fontSize: 32),
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
