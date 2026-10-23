import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:minoo_deleivery/models/order_model.dart';
import 'package:minoo_deleivery/pages/order_detail.dart';
import 'package:minoo_deleivery/providers/order/order_history_provider.dart';
import 'package:minoo_deleivery/services/auth/auth_service.dart';

/// Screen displaying customer's active and completed order history.
class OrderHistoryPage extends ConsumerWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (AuthService.currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Orders",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xfff59e0b),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline_rounded, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text(
                  "Sign In Required",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please sign in or create an account to view and track your orders.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xfff59e0b),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    "Log In / Sign Up",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final historyAsync = ref.watch(orderHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xfff59e0b),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        color: const Color(0xfff59e0b),
        onRefresh: () async {
          ref.invalidate(orderHistoryProvider);
        },
        child: historyAsync.when(
          data: (orders) {
            if (orders.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long, size: 80, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      const Text(
                        "No Orders Placed Yet",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Once you order via Express or Cart, your orders will appear here.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xfff59e0b),
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                        },
                        child: const Text("Browse Menus", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _buildOrderCard(context, order);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: Color(0xfff59e0b))),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                const SizedBox(height: 12),
                Text("Failed to load orders: $e"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(orderHistoryProvider),
                  child: const Text("Try Again"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Order order) {
    return Card(
      elevation: 2.5,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailPage(order: order),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Order ID & Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order #${order.id}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    "${order.createdAt.month}/${order.createdAt.day}/${order.createdAt.year}",
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Badges Row
              Row(
                children: [
                  _buildTypeBadge(order.orderType),
                  const SizedBox(width: 8),
                  _buildStatusBadge(order.status),
                ],
              ),
              const SizedBox(height: 12),

              // Route Info
              Row(
                children: [
                  const Icon(Icons.route, size: 18, color: Color(0xfff59e0b)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "${order.deliveryCenterName.isNotEmpty ? order.deliveryCenterName : 'Hub'} → ${order.destinationName.isNotEmpty ? order.destinationName : 'Destination'}",
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Item Preview
              if (order.orderType == OrderType.single && order.singleItem != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (order.singleItem!.menuImageUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CachedNetworkImage(
                          imageUrl: order.singleItem!.menuImageUrl,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(color: Colors.grey.shade200, width: 36, height: 36),
                          errorWidget: (_, __, ___) => const Icon(Icons.fastfood, size: 20, color: Colors.grey),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${order.singleItem!.quantity}× ${order.singleItem!.menuName}",
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ] else if (order.items.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  "${order.items.length} items in cart order",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],

              const Divider(height: 20),

              // Price and Tap prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total: Br ${order.totalPrice.toStringAsFixed(1)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xfff59e0b),
                    ),
                  ),
                  const Row(
                    children: [
                      Text("View Details", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      Icon(Icons.chevron_right, size: 18, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBadge(OrderType type) {
    final isSingle = type == OrderType.single;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isSingle ? const Color(0xfffffbeb) : const Color(0xffeff6ff),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSingle ? const Color(0xfff59e0b) : const Color(0xff3b82f6),
          width: 0.8,
        ),
      ),
      child: Text(
        type.label,
        style: TextStyle(
          fontSize: 11,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(
        status.label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: text),
      ),
    );
  }
}
