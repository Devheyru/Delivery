import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:minoo_deleivery/providers/menu/cart_provider.dart';
import 'package:minoo_deleivery/services/widgit_support.dart';
import 'package:minoo_deleivery/utils/menu_item.dart';

class DetailsPage extends ConsumerStatefulWidget {
  final String imageUrl, id, title, description, subTitle;
  final double price;

  const DetailsPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.price,
    required this.id,
  });

  @override
  ConsumerState<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends ConsumerState<DetailsPage> {
  int quantity = 1;
  late double totalPrice;

  static const Color primaryColor = Color(0xFFf59e0b);

  @override
  void initState() {
    super.initState();
    totalPrice = widget.price;
  }

  void updateQuantity(int change) {
    setState(() {
      final newQuantity = quantity + change;
      if (newQuantity >= 1 && newQuantity <= 10) {
        quantity = newQuantity;
        totalPrice = widget.price * quantity;
      }
    });
  }

  Widget buildActionButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 30, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.popAndPushNamed(context, '/cart'),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.shopping_cart,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  height: screenHeight / 3,
                  fit: BoxFit.fill,
                  placeholder:
                      (context, url) => SizedBox(
                        height: screenHeight / 3,
                        child: const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) =>
                          Center(child: Text("Imege Not Found")),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(widget.title, style: AppWidget.detailsTitleText()),
            Text(widget.subTitle, style: AppWidget.signUpTextStyle()),

            Text(
              '${widget.price.toStringAsFixed(2)} Birr',
              style: AppWidget.priceTextStyle(),
            ),
            const SizedBox(height: 30),

            // Description
            Text(
              widget.description,
              style: AppWidget.simpleOnboardingTextStyle(),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),

            // Labels
            Padding(
              padding: const EdgeInsets.only(right: 36.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Total Price",
                    style: TextStyle(fontSize: 24, color: Color(0xFF6A6A6A)),
                  ),
                  Text(
                    "Quantity",
                    style: TextStyle(fontSize: 24, color: Color(0xFF6A6A6A)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    '${totalPrice.toStringAsFixed(2)} Birr',
                    style: AppWidget.totalPriceTextStyle(),
                  ),
                ),
                Row(
                  children: [
                    buildActionButton(Icons.add, () => updateQuantity(1)),
                    const SizedBox(width: 20),
                    Text(
                      quantity.toString(),
                      style: AppWidget.leadingTextStyle(),
                    ),
                    const SizedBox(width: 20),
                    buildActionButton(Icons.remove, () => updateQuantity(-1)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            Center(
              child: Material(
                borderRadius: BorderRadius.circular(15),
                elevation: 3,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    final food = MenuItem(
                      id: int.parse(widget.id),
                      vendorId: '',
                      publicId: '',
                      menuName: widget.title,
                      menuDescription: widget.description,
                      menuPrice: widget.price,
                      menuImg: widget.imageUrl.replaceFirst(
                        'https://minoodelivery.com/',
                        '',
                      ),
                      menuCategory: widget.subTitle,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );

                    ref.read(cartProvider.notifier).addItem(food, quantity);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green,

                        content: Center(
                          child: Text(
                            ' $quantity ${widget.title} added to cart',
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width / 2,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        "Add to Cart",
                        style: TextStyle(color: Colors.white, fontSize: 26),
                      ),
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
