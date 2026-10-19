import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:minoo_deleivery/models/order_model.dart';
import 'package:minoo_deleivery/models/order_item_model.dart';

/// Screen displaying the full breakdown, status timeline, and items of a specific order.
class OrderDetailPage extends StatelessWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order #${order.id}",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xfff59e0b),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status & Type Header
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTypeBadge(order.orderType),
                        _buildStatusBadge(order.status),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTimeline(order.status),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Logistics Hub Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Delivery Details",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.hub, color: Color(0xfff59e0b), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Hub: ${order.deliveryCenterName.isNotEmpty ? order.deliveryCenterName : 'Delivery Hub #' + order.deliveryCenterId.toString()}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.redAccent, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Destination: ${order.destinationName.isNotEmpty ? order.destinationName : 'Destination #' + order.destinationId.toString()}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Items List
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.orderType == OrderType.single ? "Ordered Item" : "Cart Items (${order.items.length})",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 20),
                    if (order.items.isEmpty && order.singleItem != null)
                      _buildItemRow(order.singleItem!)
                    else if (order.items.isEmpty)
                      const Text("No items recorded for this order.")
                    else
                      ...order.items.map((item) => _buildItemRow(item)).toList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Financial Summary
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Payment Summary",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildPriceRow("Items Subtotal", "Br ${order.itemsSubtotal.toStringAsFixed(2)}"),
                    _buildPriceRow("Shipping Fee", "Br ${order.deliveryPrice.toStringAsFixed(2)}"),
                    const Divider(height: 20),
                    _buildPriceRow("Total Paid", "Br ${order.totalPrice.toStringAsFixed(2)}", isBold: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: item.menuImageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: item.menuImageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.grey.shade200, width: 50, height: 50),
                    errorWidget: (_, __, ___) => const Icon(Icons.fastfood, color: Colors.grey),
                  )
                : Container(
                    color: Colors.grey.shade200,
                    width: 50,
                    height: 50,
                    child: const Icon(Icons.fastfood, color: Colors.grey),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.menuName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  "Qty: ${item.quantity} × Br ${item.unitPrice.toStringAsFixed(1)}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            "Br ${item.lineTotal.toStringAsFixed(1)}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? const Color(0xfff59e0b) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(OrderType type) {
    final isSingle = type == OrderType.single;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isSingle ? const Color(0xfffffbeb) : const Color(0xffeff6ff),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSingle ? const Color(0xfff59e0b) : const Color(0xff3b82f6),
          width: 1,
        ),
      ),
      child: Text(
        type.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isSingle ? const Color(0xffb45309) : const Color(0xff1d4ed8),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color bg;
    Color text;
    switch (status) {
      case OrderStatus.pending:
        bg = const Color(0xfffef3c7);
        text = const Color(0xff92400e);
        break;
      case OrderStatus.processing:
        bg = const Color(0xffe0e7ff);
        text = const Color(0xff3730a3);
        break;
      case OrderStatus.outForDelivery:
        bg = const Color(0xfff3e8ff);
        text = const Color(0xff6b21a8);
        break;
      case OrderStatus.completed:
        bg = const Color(0xffdcfce7);
        text = const Color(0xff166534);
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        status.label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: text),
      ),
    );
  }

  Widget _buildTimeline(OrderStatus current) {
    final stages = [
      {'status': OrderStatus.pending, 'title': 'Pending'},
      {'status': OrderStatus.processing, 'title': 'Processing'},
      {'status': OrderStatus.outForDelivery, 'title': 'On the Way'},
      {'status': OrderStatus.completed, 'title': 'Delivered'},
    ];

    final currentIndex = OrderStatus.values.indexOf(current);

    return Row(
      children: List.generate(stages.length * 2 - 1, (index) {
        if (index.isOdd) {
          final step = index ~/ 2;
          final isPassed = step < currentIndex;
          return Expanded(
            child: Container(
              height: 2,
              color: isPassed ? const Color(0xff10b981) : Colors.grey.shade300,
            ),
          );
        } else {
          final step = index ~/ 2;
          final isPassed = step <= currentIndex;
          return Column(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: isPassed ? const Color(0xff10b981) : Colors.grey.shade300,
                child: Icon(
                  isPassed ? Icons.check : Icons.circle,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stages[step]['title'] as String,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isPassed ? FontWeight.bold : FontWeight.normal,
                  color: isPassed ? Colors.black87 : Colors.grey,
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
