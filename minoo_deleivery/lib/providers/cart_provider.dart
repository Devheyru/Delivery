import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minoo_deleivery/utils/RecomendedFoods.dart';

class CartItem {
  final FoodItem food;
  int quantity;

  CartItem({required this.food, this.quantity = 1});
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(FoodItem food, int quantity) {
    final index = state.indexWhere((item) => item.food.title == food.title);
    if (index == -1) {
      // Add new item with passed quantity
      state = [...state, CartItem(food: food, quantity: quantity)];
    } else {
      // Increment existing quantity by passed quantity
      final updatedList = [...state];
      updatedList[index].quantity += quantity;
      state = updatedList;
    }
  }

  void removeItem(FoodItem food) {
    state = state.where((item) => item.food.title != food.title).toList();
  }

  void updateQuantity(FoodItem food, int quantity) {
    final index = state.indexWhere((item) => item.food.title == food.title);
    if (index != -1) {
      final updatedList = [...state];
      if (quantity <= 0) {
        updatedList.removeAt(index);
      } else {
        updatedList[index].quantity = quantity;
      }
      state = updatedList;
    }
  }

  void clearCart() {
    state = [];
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);
