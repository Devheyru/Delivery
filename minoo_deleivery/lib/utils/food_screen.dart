import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/menu/menu_provider.dart'; // Your Riverpod provider file
import 'Recomendedfoods.dart';
import 'foodCatagories.dart';

class FoodScreen extends ConsumerStatefulWidget {
  final String searchQuery;
  const FoodScreen({super.key, required this.searchQuery});

  @override
  ConsumerState<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends ConsumerState<FoodScreen> {
  String selectedCategory = 'All';

  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final menusAsync = ref.watch(menuListProvider);

    return menusAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (menus) {
        final categorySet = <String>{};
        for (final item in menus) {
          final cat = item.menuCategory?.trim();
          if (cat != null && cat.isNotEmpty) {
            categorySet.add(cat);
          }
        }
        final categories = ['All', ...categorySet];

        final filteredList = menus.where((item) {
          final matchesCategory = selectedCategory == 'All' ||
              (item.menuCategory != null &&
                  item.menuCategory!.toLowerCase() ==
                      selectedCategory.toLowerCase());
          final matchesSearch = widget.searchQuery.isEmpty ||
              item.menuName.toLowerCase().contains(
                    widget.searchQuery.toLowerCase(),
                  ) ||
              item.menuDescription.toLowerCase().contains(
                    widget.searchQuery.toLowerCase(),
                  );
          return matchesCategory && matchesSearch;
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Productfilter(
              catagories: categories,
              selectedCategory: selectedCategory,
              onCategoryChanged: updateCategory,
            ),
            Recomendedfoods(filteredItems: filteredList),
          ],
        );
      },
    );
  }
}
