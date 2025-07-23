import 'package:flutter/material.dart';

class Productfilter extends StatelessWidget {
  final List<String> catagories = const [
    'All',
    "Bakeries",
    "Fruits",
    "Vigetables",
    "Logies",
    "Hotels",
    "Resorts",
    "Resturants",
    "Beverages",
  ];

  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const Productfilter({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: catagories.length,
        itemBuilder: (context, index) {
          final item = catagories[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => onCategoryChanged(item),
              child: Chip(
                elevation: selectedCategory == item ? 3 : 0,
                shadowColor: const Color(0xFF6A6A6A),
                backgroundColor:
                    selectedCategory == item
                        ? const Color(0xfff59e0b)
                        : const Color(0xffececf9),
                label: Text(
                  item,
                  style: TextStyle(
                    color:
                        selectedCategory == item
                            ? Colors.white
                            : Colors.black54,
                    fontSize: 16,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
