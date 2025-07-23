import 'package:flutter/material.dart';
import 'foodCatagories.dart';
// import 'food_model.dart'; // contains FoodItem, foodList
import 'RecomendedFoods.dart';

class FoodScreen extends StatefulWidget {
  final String searchQuery;
  const FoodScreen({super.key, required this.searchQuery});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  String selectedCategory = 'All';

  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredList =
        foodList.where((item) {
          final matchesCategory =
              selectedCategory == 'All' ||
              item.categories.contains(selectedCategory);
          final matchesSearch =
              widget.searchQuery.toLowerCase().isEmpty ||
              item.title.toLowerCase().contains(
                widget.searchQuery.toLowerCase(),
              ) ||
              item.subTitle.toLowerCase().contains(
                widget.searchQuery.toLowerCase(),
              );
          return matchesCategory && matchesSearch;
        }).toList();

    return Column(
      children: [
        Productfilter(
          selectedCategory: selectedCategory,
          onCategoryChanged: updateCategory,
        ),
        Recomendedfoods(filteredItems: filteredList),
      ],
    );
  }
}
