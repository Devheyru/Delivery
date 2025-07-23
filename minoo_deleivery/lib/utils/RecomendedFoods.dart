import 'dart:ui';

import 'package:flutter/material.dart';

class FoodItem {
  final String imageUrl;
  final String title;
  final String subTitle;
  bool isLiked;
  final double rating;
  final List<String> categories;

  FoodItem({
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.isLiked,
    required this.rating,
    required this.categories,
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
  ),
  FoodItem(
    imageUrl: 'assets/images/pizza1.png',
    title: 'Pizza',
    rating: 4.99,
    isLiked: false,
    subTitle: "Chicken Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
  ),
  FoodItem(
    imageUrl: 'assets/images/vegetable.jpg',
    title: 'vegetable',
    rating: 4.99,
    isLiked: false,
    subTitle: "Fresh vegetables",
    categories: ['All', 'Fruits', "vegetable"],
  ),
  FoodItem(
    imageUrl: 'assets/images/Hamburger Veggie Burger.png',
    title: 'Hamburger',
    rating: 4.99,
    isLiked: false,
    subTitle: " Veggie Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
  ),
  FoodItem(
    imageUrl: 'assets/images/Hotels.jpg',
    title: 'Hotels',
    rating: 4.99,
    isLiked: false,
    subTitle: "5 Star Hotels",
    categories: ['All', "Hotels"],
  ),
  FoodItem(
    imageUrl: 'assets/images/Hamburger Chicken Burger.png',
    title: 'Hamburger',
    rating: 4.99,
    isLiked: false,
    subTitle: "Chicken Burger",
    categories: ['All', 'Vigetables', 'Bakeries'],
  ),

  FoodItem(
    imageUrl: 'assets/images/pizza3.png',
    title: 'Pizza',
    rating: 4.99,
    isLiked: false,
    subTitle: "Chicken Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
  ),

  FoodItem(
    imageUrl: 'assets/images/Resorts.jpg',
    title: 'Resorts',
    rating: 4.99,
    isLiked: false,
    subTitle: "Best resorts ",
    categories: ['All', 'Resorts'],
  ),
  FoodItem(
    imageUrl: 'assets/images/Fried Chicken Burger.png',
    title: 'Burger',
    rating: 4.99,
    isLiked: false,
    subTitle: "Chicken Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
  ),
  FoodItem(
    imageUrl: 'assets/images/Resturants.jpg',
    title: 'Resturants',
    rating: 4.99,
    isLiked: false,
    subTitle: "Best Resturants",
    categories: ['All', 'Resturants', 'Beverages', "Juice"],
  ),
  FoodItem(
    imageUrl: 'assets/images/pizza2.png',
    title: 'Pizza',
    rating: 4.99,
    isLiked: false,
    subTitle: "Chicken Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
  ),
  FoodItem(
    imageUrl: 'assets/images/Cheeseburger.png',
    title: 'Cheeseburger',
    rating: 4.9,
    isLiked: false,
    subTitle: "Wendy's Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
  ),
  FoodItem(
    imageUrl: 'assets/images/Hamburger Veggie Burger.png',
    title: 'Hamburger',
    rating: 4.99,
    isLiked: false,
    subTitle: "Veggie Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
  ),
  FoodItem(
    imageUrl: 'assets/images/burger1.png',
    title: 'Hamburger',
    rating: 4.99,
    isLiked: false,
    subTitle: "Chicken Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
  ),
  FoodItem(
    imageUrl: 'assets/images/burger2.png',
    title: 'Burger',
    rating: 4.99,
    isLiked: false,
    subTitle: "Chicken Burger",
    categories: ['All', 'Fruits', 'Bakeries'],
  ),

  FoodItem(
    imageUrl: 'assets/images/Beverages.jpg',
    title: 'Juice',
    rating: 4.99,
    isLiked: false,
    subTitle: "Fresh and cool",
    categories: ['All', 'Fruits', 'Beverages', "Juice"],
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
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(0),
        itemCount: widget.filteredItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // two items per row

          childAspectRatio: 0.75, // adjust as needed for card shape
        ),
        itemBuilder: (context, index) {
          final item = widget.filteredItems[index];

          return Padding(
            padding: const EdgeInsets.only(left: 9.0),
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
                      boxShadow: [
                        const BoxShadow(
                          color: Color(0xFF6A6A6A),
                          spreadRadius: 0,
                          blurRadius: 3,
                          offset: Offset(-1, -1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              // Elliptical blurred shadow
                              Positioned(
                                bottom: 0,
                                child: ImageFiltered(
                                  imageFilter: ImageFilter.blur(
                                    sigmaX: 15,
                                    sigmaY: 5,
                                  ), // horizontal + vertical blur
                                  child: Container(
                                    width: 91,
                                    height: 11,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(0, 0, 0, 0.35),
                                      borderRadius: BorderRadius.circular(
                                        30,
                                      ), // elliptical shape
                                    ),
                                  ),
                                ),
                              ),

                              // The main image
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
                              padding: const EdgeInsets.only(left: 8.0),
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
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            top: 2.0,
                            bottom: 2.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.star, color: Color(0xfff59e0b)),
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
                                    item.isLiked == false
                                        ? const Icon(
                                          Icons.favorite_outline_outlined,
                                          color: Color(0xFFf59e0b),
                                        )
                                        : const Icon(
                                          Icons.favorite_outlined,
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
              ],
            ),
          );
        },
      ),
    );
  }
}
