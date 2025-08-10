import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:minoo_deleivery/pages/details.dart';

class FoodItem {
  final String imageUrl;
  final String title;
  final String subTitle;
  bool isLiked;
  final double rating;
  final List<String> categories;
  final String description;
  final double price;

  FoodItem({
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.isLiked,
    required this.rating,
    required this.categories,
    required this.description,
    required this.price,
  });
}

List<FoodItem> foodList = [
  FoodItem(
    imageUrl: 'assets/images/Cheeseburger.png',
    title: 'Cheeseburger',
    rating: 4.9,
    isLiked: false,
    subTitle: "Wendy's Burger",
    categories: ['All', 'Bakeries'],
    price: 10,
    description:
        "The Cheeseburger Wendy's Burger is a classic fast food burger that packs a punch of flavor in every bite. Made with a juicy beef patty cooked to perfection, it's topped with melted American cheese, crispy lettuce, ripe tomato, and crunchy pickles. ",
  ),
  FoodItem(
    imageUrl: 'assets/images/pizza1.png',
    title: 'Pizza',
    rating: 4.99,
    isLiked: false,
    subTitle: "Chicken Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
    price: 10,
    description:
        "The Cheeseburger Wendy's Burger is a classic fast food burger that packs a punch of flavor in every bite. Made with a juicy beef patty cooked to perfection, it's topped with melted American cheese, crispy lettuce, ripe tomato, and crunchy pickles. ",
  ),
  FoodItem(
    imageUrl: 'assets/images/vegetable.jpg',
    title: 'vegetable',
    rating: 4.99,
    isLiked: false,
    subTitle: "Fresh vegetables",
    categories: ['All', 'Fruits', "vegetable"],
    price: 10,
    description:
        "The Cheeseburger Wendy's Burger is a classic fast food burger that packs a punch of flavor in every bite. Made with a juicy beef patty cooked to perfection, it's topped with melted American cheese, crispy lettuce, ripe tomato, and crunchy pickles. ",
  ),
  FoodItem(
    imageUrl: 'assets/images/Hamburger Veggie Burger.png',
    title: 'Hamburger',
    rating: 4.99,
    isLiked: false,
    subTitle: " Veggie Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
    price: 10,
    description:
        "The Cheeseburger Wendy's Burger is a classic fast food burger that packs a punch of flavor in every bite. Made with a juicy beef patty cooked to perfection, it's topped with melted American cheese, crispy lettuce, ripe tomato, and crunchy pickles. ",
  ),
  FoodItem(
    imageUrl: 'assets/images/Hotels.jpg',
    title: 'Hotels',
    rating: 4.99,
    isLiked: false,
    subTitle: "5 Star Hotels",
    categories: ['All', "Hotels"],
    price: 10,
    description:
        "The Cheeseburger Wendy's Burger is a classic fast food burger that packs a punch of flavor in every bite. Made with a juicy beef patty cooked to perfection, it's topped with melted American cheese, crispy lettuce, ripe tomato, and crunchy pickles. ",
  ),
  FoodItem(
    imageUrl: 'assets/images/Hamburger Chicken Burger.png',
    title: 'Hamburger',
    rating: 4.99,
    isLiked: false,
    subTitle: "Chicken Burger",
    categories: ['All', 'Vigetables', 'Bakeries'],
    price: 10,
    description:
        "The Cheeseburger Wendy's Burger is a classic fast food burger that packs a punch of flavor in every bite. Made with a juicy beef patty cooked to perfection, it's topped with melted American cheese, crispy lettuce, ripe tomato, and crunchy pickles. ",
  ),
  FoodItem(
    imageUrl: 'assets/images/pizza3.png',
    title: 'Pizza',
    rating: 4.99,
    isLiked: false,
    subTitle: "Chicken Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
    price: 10,
    description:
        "The Cheeseburger Wendy's Burger is a classic fast food burger that packs a punch of flavor in every bite. Made with a juicy beef patty cooked to perfection, it's topped with melted American cheese, crispy lettuce, ripe tomato, and crunchy pickles. ",
  ),
  FoodItem(
    imageUrl: 'assets/images/Resorts.jpg',
    title: 'Resorts',
    rating: 4.99,
    isLiked: false,
    subTitle: "Best resorts ",
    categories: ['All', 'Resorts'],
    price: 10,
    description:
        "The Cheeseburger Wendy's Burger is a classic fast food burger that packs a punch of flavor in every bite. Made with a juicy beef patty cooked to perfection, it's topped with melted American cheese, crispy lettuce, ripe tomato, and crunchy pickles. ",
  ),
  FoodItem(
    imageUrl: 'assets/images/Fried Chicken Burger.png',
    title: 'Burger',
    rating: 4.99,
    isLiked: false,
    subTitle: "Chicken Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
    price: 10,
    description:
        "The Cheeseburger Wendy's Burger is a classic fast food burger that packs a punch of flavor in every bite. Made with a juicy beef patty cooked to perfection, it's topped with melted American cheese, crispy lettuce, ripe tomato, and crunchy pickles. ",
  ),
  FoodItem(
    imageUrl: 'assets/images/Resturants.jpg',
    title: 'Resturants',
    rating: 4.99,
    isLiked: false,
    subTitle: "Best Resturants",
    categories: ['All', 'Resturants', 'Beverages', "Juice"],
    price: 10,
    description:
        "The Cheeseburger Wendy's Burger is a classic fast food burger that packs a punch of flavor in every bite. Made with a juicy beef patty cooked to perfection, it's topped with melted American cheese, crispy lettuce, ripe tomato, and crunchy pickles. ",
  ),
  FoodItem(
    imageUrl: 'assets/images/pizza2.png',
    title: 'Pizza',
    rating: 4.99,
    isLiked: false,
    subTitle: "Chicken Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
    price: 10,
    description:
        "The Cheeseburger Wendy's Burger is a classic fast food burger that packs a punch of flavor in every bite. Made with a juicy beef patty cooked to perfection, it's topped with melted American cheese, crispy lettuce, ripe tomato, and crunchy pickles. ",
  ),
  FoodItem(
    imageUrl: 'assets/images/Cheeseburger.png',
    title: 'Cheeseburger',
    rating: 4.9,
    isLiked: false,
    subTitle: "Wendy's Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
    price: 10,
    description:
        "The Cheeseburger Wendy's Burger is a classic fast food burger that packs a punch of flavor in every bite. Made with a juicy beef patty cooked to perfection, it's topped with melted American cheese, crispy lettuce, ripe tomato, and crunchy pickles. ",
  ),
  FoodItem(
    imageUrl: 'assets/images/Hamburger Veggie Burger.png',
    title: 'Hamburger',
    rating: 4.99,
    isLiked: false,
    subTitle: "Veggie Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
    price: 10,
    description:
        "The Cheeseburger Wendy's Burger is a classic fast food burger that packs a punch of flavor in every bite. Made with a juicy beef patty cooked to perfection, it's topped with melted American cheese, crispy lettuce, ripe tomato, and crunchy pickles. ",
  ),
  FoodItem(
    imageUrl: 'assets/images/burger1.png',
    title: 'Hamburger',
    rating: 4.99,
    isLiked: false,
    subTitle: "Chicken Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
    price: 10,
    description:
        "The Cheeseburger Wendy's Burger is a classic fast food burger that packs a punch of flavor in every bite. Made with a juicy beef patty cooked to perfection, it's topped with melted American cheese, crispy lettuce, ripe tomato, and crunchy pickles. ",
  ),
  FoodItem(
    imageUrl: 'assets/images/burger2.png',
    title: 'Burger',
    rating: 4.99,
    isLiked: false,
    subTitle: "Chicken Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
    price: 10,
    description:
        "The Cheeseburger Wendy's Burger is a classic fast food burger that packs a punch of flavor in every bite. Made with a juicy beef patty cooked to perfection, it's topped with melted American cheese, crispy lettuce, ripe tomato, and crunchy pickles. ",
  ),
  FoodItem(
    imageUrl: 'assets/images/Beverages.jpg',
    title: 'Juice',
    rating: 4.99,
    isLiked: false,
    subTitle: "Fresh and cool",
    categories: ['All', 'Fruits', 'Beverages', "Juice"],
    price: 10,
    description:
        "The Cheeseburger Wendy's Burger is a classic fast food burger that packs a punch of flavor in every bite. Made with a juicy beef patty cooked to perfection, it's topped with melted American cheese, crispy lettuce, ripe tomato, and crunchy pickles. ",
  ),
];

class Recomendedfoods extends StatefulWidget {
  final List<FoodItem> filteredItems;
  const Recomendedfoods({super.key, required this.filteredItems});

  @override
  State<Recomendedfoods> createState() => _RecomendedfoodsState();
}

class _RecomendedfoodsState extends State<Recomendedfoods> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: widget.filteredItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // two items per row
          childAspectRatio: 0.75, // card shape ratio
        ),
        itemBuilder: (context, index) {
          final item = widget.filteredItems[index];
          return Padding(
            padding: const EdgeInsets.only(left: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 215,
                  width: 150,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFF6A6A6A),
                          blurRadius: 3,
                          offset: Offset(-1, -1),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => DetailsPage(
                                    imageUrl: item.imageUrl,
                                    title: item.title,
                                    subTitle: item.subTitle,
                                    description: item.description,
                                    price: item.price,
                                  ),
                            ),
                          ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Positioned(
                                  bottom: 0,
                                  child: ImageFiltered(
                                    imageFilter: ImageFilter.blur(
                                      sigmaX: 15,
                                      sigmaY: 5,
                                    ),
                                    child: Container(
                                      width: 91,
                                      height: 11,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                          0,
                                          0,
                                          0,
                                          0.35,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 110,
                                  height: 111.76,
                                  child: Image.asset(item.imageUrl),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  color: Color(0xFF3C2F2F),
                                  fontFamily: 'roboto',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  item.subTitle,
                                  style: const TextStyle(
                                    color: Color(0xFF3C2F2F),
                                    fontFamily: 'roboto',
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Color(0xfff59e0b),
                                    ),
                                    Text(
                                      item.rating.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon:
                                      item.isLiked
                                          ? const Icon(
                                            Icons.favorite_outlined,
                                            color: Color(0xFFf59e0b),
                                          )
                                          : const Icon(
                                            Icons.favorite_outline_outlined,
                                            color: Color(0xFFf59e0b),
                                          ),
                                  onPressed: () {
                                    setState(() {
                                      foodList[index].isLiked =
                                          !foodList[index].isLiked;
                                    });
                                  },
                                ),
                              ],
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
        },
      ),
    );
  }
}
