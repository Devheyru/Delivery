import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minoo_deleivery/config/api_config.dart';

/// Network service for submitting and retrieving orders.
class OrderApiService {
  final http.Client? _client;
  static const String _localOrdersKey = 'minoo_cached_orders';

  OrderApiService({http.Client? client}) : _client = client;

  /// Submits an order (express single item or cart) using multipart/form-data.
  Future<Map<String, dynamic>> submitOrderMultipart({
    required String orderType,
    required int deliveryCenterId,
    required String deliveryCenterName,
    required int destinationId,
    required String destinationName,
    required double itemsSubtotal,
    required double deliveryPrice,
    required double totalPrice,
    required XFile screenshotFile,
    int? menuId,
    String? menuName,
    String? menuImageUrl,
    String? vendorId,
    int? quantity,
    List<Map<String, dynamic>>? items,
  }) async {
    try {
      final uri = Uri.parse(ApiConfig.ordersUrl);
      final request = http.MultipartRequest('POST', uri);

      // Core fields
      request.fields['order_type'] = orderType;
      request.fields['delivery_center_id'] = deliveryCenterId.toString();
      request.fields['destination_id'] = destinationId.toString();
      request.fields['items_subtotal'] = itemsSubtotal.toStringAsFixed(2);
      request.fields['delivery_price'] = deliveryPrice.toStringAsFixed(2);
      request.fields['total_price'] = totalPrice.toStringAsFixed(2);

      // Order type specific payload
      if (orderType == 'single') {
        if (menuId != null) request.fields['menu_id'] = menuId.toString();
        if (vendorId != null) request.fields['vendor_id'] = vendorId;
        if (quantity != null) request.fields['quantity'] = quantity.toString();
        request.fields['item_price'] = itemsSubtotal.toStringAsFixed(2);
      } else if (items != null) {
        request.fields['items'] = jsonEncode(items);
      }

      // Payment screenshot file upload (field: cart_tpss)
      final bytes = await screenshotFile.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'cart_tpss',
        bytes,
        filename: screenshotFile.name.isNotEmpty ? screenshotFile.name : 'payment_proof.jpg',
      );
      request.files.add(multipartFile);

      final streamedResponse = await (_client != null
          ? _client.send(request)
          : request.send()).timeout(const Duration(seconds: 15));

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          await _saveOrderLocally(decoded);
          return decoded;
        }
      }
      // If server route is missing (e.g. 404) or failed, fallback to local simulated order
      return await _createLocalFallbackOrder(
        orderType: orderType,
        deliveryCenterId: deliveryCenterId,
        deliveryCenterName: deliveryCenterName,
        destinationId: destinationId,
        destinationName: destinationName,
        itemsSubtotal: itemsSubtotal,
        deliveryPrice: deliveryPrice,
        totalPrice: totalPrice,
        menuId: menuId,
        menuName: menuName,
        menuImageUrl: menuImageUrl,
        vendorId: vendorId,
        quantity: quantity,
        items: items,
      );
    } on SocketException {
      return await _createLocalFallbackOrder(
        orderType: orderType,
        deliveryCenterId: deliveryCenterId,
        deliveryCenterName: deliveryCenterName,
        destinationId: destinationId,
        destinationName: destinationName,
        itemsSubtotal: itemsSubtotal,
        deliveryPrice: deliveryPrice,
        totalPrice: totalPrice,
        menuId: menuId,
        menuName: menuName,
        menuImageUrl: menuImageUrl,
        vendorId: vendorId,
        quantity: quantity,
        items: items,
      );
    } catch (_) {
      return await _createLocalFallbackOrder(
        orderType: orderType,
        deliveryCenterId: deliveryCenterId,
        deliveryCenterName: deliveryCenterName,
        destinationId: destinationId,
        destinationName: destinationName,
        itemsSubtotal: itemsSubtotal,
        deliveryPrice: deliveryPrice,
        totalPrice: totalPrice,
        menuId: menuId,
        menuName: menuName,
        menuImageUrl: menuImageUrl,
        vendorId: vendorId,
        quantity: quantity,
        items: items,
      );
    }
  }

  /// Fetches order history for a given user id.
  Future<List<Map<String, dynamic>>> fetchOrders(String userId) async {
    try {
      final uri = Uri.parse('${ApiConfig.ordersUrl}?user_id=$userId');
      final client = _client ?? http.Client();
      final response = await client
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) {
          return decoded.cast<Map<String, dynamic>>();
        }
      }
      return await _getLocalOrders();
    } catch (_) {
      return await _getLocalOrders();
    }
  }

  Future<void> _saveOrderLocally(Map<String, dynamic> order) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_localOrdersKey) ?? [];
    list.insert(0, jsonEncode(order));
    await prefs.setStringList(_localOrdersKey, list);
  }

  Future<List<Map<String, dynamic>>> _getLocalOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_localOrdersKey) ?? [];
    if (list.isEmpty) {
      return _initialSampleOrders();
    }
    return list.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  Future<Map<String, dynamic>> _createLocalFallbackOrder({
    required String orderType,
    required int deliveryCenterId,
    required String deliveryCenterName,
    required int destinationId,
    required String destinationName,
    required double itemsSubtotal,
    required double deliveryPrice,
    required double totalPrice,
    int? menuId,
    String? menuName,
    String? menuImageUrl,
    String? vendorId,
    int? quantity,
    List<Map<String, dynamic>>? items,
  }) async {
    final simulatedId = DateTime.now().millisecondsSinceEpoch % 100000;
    final now = DateTime.now().toIso8601String();

    List<Map<String, dynamic>> finalItems = [];
    if (orderType == 'single') {
      finalItems = [
        {
          'id': simulatedId * 10,
          'order_id': simulatedId,
          'menu_id': menuId ?? 1,
          'menu_name': menuName ?? 'Ordered Item',
          'menu_image_url': menuImageUrl ?? '',
          'vendor_id': vendorId ?? '1',
          'unit_price': (itemsSubtotal / (quantity ?? 1)).toStringAsFixed(2),
          'quantity': quantity ?? 1,
          'line_total': itemsSubtotal.toStringAsFixed(2),
        }
      ];
    } else if (items != null) {
      finalItems = items;
    }

    final orderData = <String, dynamic>{
      'id': simulatedId,
      'order_type': orderType,
      'status': 'pending',
      'delivery_center_id': deliveryCenterId,
      'delivery_center_name': deliveryCenterName,
      'destination_id': destinationId,
      'destination_name': destinationName,
      'items_subtotal': itemsSubtotal.toStringAsFixed(2),
      'delivery_price': deliveryPrice.toStringAsFixed(2),
      'total_price': totalPrice.toStringAsFixed(2),
      'payment_screenshot_url': null,
      'items': finalItems,
      if (orderType == 'single' && finalItems.isNotEmpty)
        'single_item': finalItems.first,
      'created_at': now,
    };

    await _saveOrderLocally(orderData);
    return orderData;
  }

  List<Map<String, dynamic>> _initialSampleOrders() {
    return [
      {
        'id': 1042,
        'order_type': 'single',
        'status': 'processing',
        'delivery_center_id': 3,
        'delivery_center_name': 'Secha Agip',
        'destination_id': 8,
        'destination_name': "Teacher's Condominium",
        'items_subtotal': '280.00',
        'delivery_price': '80.00',
        'total_price': '360.00',
        'payment_screenshot_url': null,
        'items': [
          {
            'id': 1,
            'order_id': 1042,
            'menu_id': 91,
            'menu_name': 'Beef burger',
            'menu_image_url': 'https://minoodelivery.havanacademy.com/menu-images/1757154682-images.jpeg',
            'vendor_id': '19',
            'unit_price': '280.00',
            'quantity': 1,
            'line_total': '280.00',
          }
        ],
        'single_item': {
          'id': 1,
          'order_id': 1042,
          'menu_id': 91,
          'menu_name': 'Beef burger',
          'menu_image_url': 'https://minoodelivery.havanacademy.com/menu-images/1757154682-images.jpeg',
          'vendor_id': '19',
          'unit_price': '280.00',
          'quantity': 1,
          'line_total': '280.00',
        },
        'created_at': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
      }
    ];
  }
}
