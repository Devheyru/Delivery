import 'package:minoo_deleivery/models/order_item_model.dart';

/// Supported types of orders in Minoo Delivery.
enum OrderType {
  single,
  cart;

  static OrderType fromString(String? value) {
    if (value?.toLowerCase() == 'single') return OrderType.single;
    return OrderType.cart;
  }

  String get label => this == OrderType.single ? 'Single Item' : 'Cart Order';
}

/// Lifecycle stages of an order.
enum OrderStatus {
  pending,
  processing,
  outForDelivery,
  completed;

  static OrderStatus fromString(String? value) {
    final normalized = value?.toLowerCase().replaceAll(' ', '_') ?? '';
    switch (normalized) {
      case 'processing':
        return OrderStatus.processing;
      case 'out_for_delivery':
      case 'outfordelivery':
        return OrderStatus.outForDelivery;
      case 'completed':
        return OrderStatus.completed;
      case 'pending':
      default:
        return OrderStatus.pending;
    }
  }

  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.completed:
        return 'Completed';
    }
  }
}

/// Represents an order placed by a customer.
class Order {
  final int id;
  final OrderType orderType;
  final OrderStatus status;
  final int deliveryCenterId;
  final String deliveryCenterName;
  final int destinationId;
  final String destinationName;
  final double itemsSubtotal;
  final double deliveryPrice;
  final double totalPrice;
  final String? paymentScreenshotUrl;
  final List<OrderItem> items;
  final OrderItem? singleItem;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.orderType,
    required this.status,
    required this.deliveryCenterId,
    required this.deliveryCenterName,
    required this.destinationId,
    required this.destinationName,
    required this.itemsSubtotal,
    required this.deliveryPrice,
    required this.totalPrice,
    this.paymentScreenshotUrl,
    required this.items,
    this.singleItem,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final type = OrderType.fromString(json['order_type']?.toString());
    final status = OrderStatus.fromString(json['status']?.toString());

    final subtotal = double.tryParse(json['items_subtotal']?.toString() ?? '') ?? 0.0;
    final delivery = double.tryParse(json['delivery_price']?.toString() ?? '') ?? 0.0;
    final total = double.tryParse(json['total_price']?.toString() ?? '') ?? (subtotal + delivery);

    List<OrderItem> itemList = [];
    if (json['items'] is List) {
      itemList = (json['items'] as List)
          .map((e) => OrderItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    OrderItem? single;
    if (json['single_item'] is Map) {
      single = OrderItem.fromJson(Map<String, dynamic>.from(json['single_item']));
    } else if (type == OrderType.single && itemList.isNotEmpty) {
      single = itemList.first;
    }

    return Order(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      orderType: type,
      status: status,
      deliveryCenterId: int.tryParse(json['delivery_center_id']?.toString() ?? '') ?? 0,
      deliveryCenterName: json['delivery_center_name']?.toString() ?? '',
      destinationId: int.tryParse(json['destination_id']?.toString() ?? '') ?? 0,
      destinationName: json['destination_name']?.toString() ?? '',
      itemsSubtotal: subtotal,
      deliveryPrice: delivery,
      totalPrice: total,
      paymentScreenshotUrl: json['payment_screenshot_url']?.toString(),
      items: itemList,
      singleItem: single,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_type': orderType.name,
      'status': status.name,
      'delivery_center_id': deliveryCenterId,
      'delivery_center_name': deliveryCenterName,
      'destination_id': destinationId,
      'destination_name': destinationName,
      'items_subtotal': itemsSubtotal,
      'delivery_price': deliveryPrice,
      'total_price': totalPrice,
      'payment_screenshot_url': paymentScreenshotUrl,
      'items': items.map((e) => e.toJson()).toList(),
      if (singleItem != null) 'single_item': singleItem!.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
