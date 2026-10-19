import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minoo_deleivery/models/delivery_center_model.dart';
import 'package:minoo_deleivery/models/destination_address.dart';
import 'package:minoo_deleivery/models/order_model.dart';
import 'package:minoo_deleivery/providers/menu/cart_provider.dart';
import 'package:minoo_deleivery/repositories/order/order_repository.dart';
import 'package:minoo_deleivery/utils/menu_item.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository();
});

/// Async notifier managing state during express and cart order submission.
class OrderSubmissionNotifier extends StateNotifier<AsyncValue<Order?>> {
  final OrderRepository _repository;
  final Ref _ref;

  OrderSubmissionNotifier(this._repository, this._ref)
      : super(const AsyncValue.data(null));

  /// Submits an express single item order.
  Future<Order?> submitExpressOrder({
    required MenuItem menuItem,
    required int quantity,
    required DeliveryCenter center,
    required Destination destination,
    required double deliveryPrice,
    required XFile screenshotFile,
  }) async {
    state = const AsyncValue.loading();
    try {
      final itemPrice = menuItem.menuPrice * quantity;
      final totalPrice = itemPrice + deliveryPrice;

      final order = await _repository.submitSingleOrder(
        deliveryCenterId: center.id,
        deliveryCenterName: center.name,
        destinationId: destination.id,
        destinationName: destination.name,
        menuId: menuItem.id,
        menuName: menuItem.menuName,
        menuImageUrl: menuItem.imageUrl,
        vendorId: menuItem.vendorId,
        quantity: quantity,
        itemPrice: itemPrice,
        deliveryPrice: deliveryPrice,
        totalPrice: totalPrice,
        screenshotFile: screenshotFile,
      );

      state = AsyncValue.data(order);
      return order;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Submits a multi-item cart order.
  Future<Order?> submitCartOrder({
    required List<CartItem> cartItems,
    required DeliveryCenter center,
    required Destination destination,
    required double deliveryPrice,
    required XFile screenshotFile,
  }) async {
    state = const AsyncValue.loading();
    try {
      final itemsPayload = cartItems.map((item) {
        final lineTotal = item.food.menuPrice * item.quantity;
        return {
          'menu_id': item.food.id,
          'vendor_id': item.food.vendorId,
          'menu_name': item.food.menuName,
          'menu_image_url': item.food.imageUrl,
          'quantity': item.quantity,
          'unit_price': item.food.menuPrice.toStringAsFixed(2),
          'line_total': lineTotal.toStringAsFixed(2),
        };
      }).toList();

      final subtotal = cartItems.fold<double>(
        0.0,
        (sum, item) => sum + (item.food.menuPrice * item.quantity),
      );
      final totalPrice = subtotal + deliveryPrice;

      final order = await _repository.submitCartOrder(
        deliveryCenterId: center.id,
        deliveryCenterName: center.name,
        destinationId: destination.id,
        destinationName: destination.name,
        itemsSubtotal: subtotal,
        deliveryPrice: deliveryPrice,
        totalPrice: totalPrice,
        items: itemsPayload,
        screenshotFile: screenshotFile,
      );

      // On successful submission, clear cart
      _ref.read(cartProvider.notifier).clearCart();

      state = AsyncValue.data(order);
      return order;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final orderSubmissionProvider =
    StateNotifierProvider<OrderSubmissionNotifier, AsyncValue<Order?>>((ref) {
  final repo = ref.watch(orderRepositoryProvider);
  return OrderSubmissionNotifier(repo, ref);
});
