import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:minoo_deleivery/models/delivery_center_model.dart';
import 'package:minoo_deleivery/models/destination_address.dart';
import 'package:minoo_deleivery/pages/payment_Proof.dart';
import 'package:minoo_deleivery/providers/address/address_providers.dart';
import 'package:minoo_deleivery/providers/order/order_provider.dart';
import 'package:minoo_deleivery/services/auth/auth_service.dart';
import 'package:minoo_deleivery/services/widgit_support.dart';
import 'package:minoo_deleivery/utils/menu_item.dart';

/// Screen for immediate single-item "Express" checkout.
class ExpressCheckoutPage extends ConsumerStatefulWidget {
  final MenuItem menuItem;
  final int quantity;

  const ExpressCheckoutPage({
    super.key,
    required this.menuItem,
    required this.quantity,
  });

  @override
  ConsumerState<ExpressCheckoutPage> createState() => _ExpressCheckoutPageState();
}

class _ExpressCheckoutPageState extends ConsumerState<ExpressCheckoutPage> {
  DeliveryCenter? _selectedCenter;
  Destination? _selectedDestination;

  @override
  Widget build(BuildContext context) {
    final centersAsync = ref.watch(deliveryCentersProvider);
    final itemSubtotal = widget.menuItem.menuPrice * widget.quantity;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Express Checkout",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
            // Ordered Item Summary Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.menuItem.imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: widget.menuItem.imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(
                                color: Colors.grey.shade200,
                                width: 80,
                                height: 80,
                                child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                              ),
                              errorWidget: (_, __, ___) => Container(
                                color: Colors.grey.shade200,
                                width: 80,
                                height: 80,
                                child: const Icon(Icons.fastfood, color: Colors.grey),
                              ),
                            )
                          : Container(
                              color: Colors.grey.shade200,
                              width: 80,
                              height: 80,
                              child: const Icon(Icons.fastfood, color: Colors.grey),
                            ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.menuItem.menuName,
                            style: AppWidget.boldTextFieldStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Unit Price: Br ${widget.menuItem.menuPrice.toStringAsFixed(1)}",
                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Quantity: ${widget.quantity} × Br ${widget.menuItem.menuPrice.toStringAsFixed(1)} = Br ${itemSubtotal.toStringAsFixed(1)}",
                            style: const TextStyle(
                              color: Color(0xfff59e0b),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Logistics Hub & Destination Selection
            const Text(
              "Delivery Location",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Delivery Center Dropdown
            centersAsync.when(
              data: (centers) {
                if (centers.isEmpty) {
                  return const Text("No delivery centers available.");
                }
                return DropdownButtonFormField<DeliveryCenter>(
                  value: _selectedCenter,
                  hint: const Text("Select Delivery Center Hub"),
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    prefixIcon: const Icon(Icons.hub, color: Color(0xfff59e0b)),
                  ),
                  items: centers.map((center) {
                    return DropdownMenuItem<DeliveryCenter>(
                      value: center,
                      child: Text(center.name),
                    );
                  }).toList(),
                  onChanged: (center) {
                    setState(() {
                      _selectedCenter = center;
                      _selectedDestination = null;
                    });
                  },
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text("Error loading centers: $e"),
            ),

            const SizedBox(height: 14),

            // Destination Dropdown (dependent on selected center)
            if (_selectedCenter != null)
              Consumer(
                builder: (context, ref, _) {
                  final destAsync = ref.watch(destinationsProvider(_selectedCenter!.id));
                  return destAsync.when(
                    data: (destinations) {
                      if (destinations.isEmpty) {
                        return const Text("No drop-off points for this center.");
                      }
                      return DropdownButtonFormField<Destination>(
                        value: _selectedDestination,
                        hint: const Text("Select Final Destination"),
                        isExpanded: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          prefixIcon: const Icon(Icons.location_on, color: Color(0xfff59e0b)),
                        ),
                        items: destinations.map((dest) {
                          return DropdownMenuItem<Destination>(
                            value: dest,
                            child: Text(dest.name),
                          );
                        }).toList(),
                        onChanged: (dest) {
                          setState(() {
                            _selectedDestination = dest;
                          });
                        },
                      );
                    },
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text("Error loading destinations: $e"),
                  );
                },
              ),

            const SizedBox(height: 24),

            // Price Breakdown Section
            if (_selectedCenter != null && _selectedDestination != null)
              Consumer(
                builder: (context, ref, _) {
                  final distanceAsync = ref.watch(
                    distanceProvider(DistanceIds(_selectedCenter!.id, _selectedDestination!.id)),
                  );

                  return distanceAsync.when(
                    data: (distance) {
                      final deliveryFee = distance * 50.0;
                      final grandTotal = itemSubtotal + deliveryFee;

                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pricing Summary",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              _buildRow("Item Subtotal", "Br ${itemSubtotal.toStringAsFixed(1)}"),
                              _buildRow("Distance", "${distance.toStringAsFixed(2)} km"),
                              _buildRow("Delivery Fee (${distance.toStringAsFixed(1)} × 50)", "Br ${deliveryFee.toStringAsFixed(1)}"),
                              const Divider(height: 24, thickness: 1.2),
                              _buildRow("Grand Total", "Br ${grandTotal.toStringAsFixed(1)}", isBold: true),
                              const SizedBox(height: 20),

                              // Checkout CTA
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.payment, color: Colors.white),
                                  label: const Text(
                                    "Upload Payment & Place Order",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xfff59e0b),
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  onPressed: () async {
                                    final isAuth = await AuthService.requireAuth(
                                      context,
                                      action: 'submit this express order',
                                    );
                                    if (!isAuth) return;
                                    if (!context.mounted) return;

                                    showPaymentDialog(
                                      context,
                                      onSubmit: (file) async {
                                        await ref.read(orderSubmissionProvider.notifier).submitExpressOrder(
                                              menuItem: widget.menuItem,
                                              quantity: widget.quantity,
                                              center: _selectedCenter!,
                                              destination: _selectedDestination!,
                                              deliveryPrice: deliveryFee,
                                              screenshotFile: file,
                                            );
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text("Express order placed successfully!"),
                                            ),
                                          );
                                          Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/orders',
                                            (route) => route.settings.name == '/home',
                                          );
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text("Error calculating distance: $e")),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? const Color(0xfff59e0b) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
