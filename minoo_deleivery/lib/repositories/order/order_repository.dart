import 'package:image_picker/image_picker.dart';
import 'package:minoo_deleivery/models/order_model.dart';
import 'package:minoo_deleivery/services/order/order_api_service.dart';

/// Repository that abstracts order placement and history retrieval into strongly-typed domain models.
class OrderRepository {
  final OrderApiService _apiService;

  OrderRepository({OrderApiService? apiService})
      : _apiService = apiService ?? OrderApiService();

  /// Submits an express single-item order.
  Future<Order> submitSingleOrder({
    required int deliveryCenterId,
    required String deliveryCenterName,
    required int destinationId,
    required String destinationName,
    required int menuId,
    required String menuName,
    required String menuImageUrl,
    required String vendorId,
    required int quantity,
    required double itemPrice,
    required double deliveryPrice,
    required double totalPrice,
    required XFile screenshotFile,
  }) async {
    final raw = await _apiService.submitOrderMultipart(
      orderType: 'single',
      deliveryCenterId: deliveryCenterId,
      deliveryCenterName: deliveryCenterName,
      destinationId: destinationId,
      destinationName: destinationName,
      itemsSubtotal: itemPrice,
      deliveryPrice: deliveryPrice,
      totalPrice: totalPrice,
      screenshotFile: screenshotFile,
      menuId: menuId,
      menuName: menuName,
      menuImageUrl: menuImageUrl,
      vendorId: vendorId,
      quantity: quantity,
    );
    return Order.fromJson(raw);
  }

  /// Submits a multi-item cart order.
  Future<Order> submitCartOrder({
    required int deliveryCenterId,
    required String deliveryCenterName,
    required int destinationId,
    required String destinationName,
    required double itemsSubtotal,
    required double deliveryPrice,
    required double totalPrice,
    required List<Map<String, dynamic>> items,
    required XFile screenshotFile,
  }) async {
    final raw = await _apiService.submitOrderMultipart(
      orderType: 'cart',
      deliveryCenterId: deliveryCenterId,
      deliveryCenterName: deliveryCenterName,
      destinationId: destinationId,
      destinationName: destinationName,
      itemsSubtotal: itemsSubtotal,
      deliveryPrice: deliveryPrice,
      totalPrice: totalPrice,
      screenshotFile: screenshotFile,
      items: items,
    );
    return Order.fromJson(raw);
  }

  /// Fetches orders for a customer.
  Future<List<Order>> fetchOrders(String userId) async {
    final rawList = await _apiService.fetchOrders(userId);
    return rawList.map((item) => Order.fromJson(item)).toList();
  }
}
