import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minoo_deleivery/utils/menu_item.dart';

class CartItem {
  final MenuItem food;
  int quantity;

  CartItem({required this.food, this.quantity = 1});
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(MenuItem food, int quantity) {
    final index = state.indexWhere(
      (item) => item.food.menuName == food.menuName,
    );
    if (index == -1) {
      state = [...state, CartItem(food: food, quantity: quantity)];
    } else {
      final updatedList = [...state];
      updatedList[index].quantity += quantity;
      state = updatedList;
    }
  }

  void removeItem(MenuItem food) {
    state = state.where((item) => item.food.menuName != food.menuName).toList();
  }

  void updateQuantity(MenuItem food, int quantity) {
    final index = state.indexWhere(
      (item) => item.food.menuName == food.menuName,
    );
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

final totalPriceProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.fold<double>(
    0,
    (previousValue, element) =>
        previousValue + element.food.menuPrice * element.quantity,
  );
});
