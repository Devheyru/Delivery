import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minoo_deleivery/pages/payment_Proof.dart';
import 'package:minoo_deleivery/providers/address/address_providers.dart';
import 'package:minoo_deleivery/providers/menu/cart_provider.dart';

class CheckoutSummaryPage extends ConsumerWidget {
  const CheckoutSummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtotalPrice = ref.watch(totalPriceProvider);
    final center = ref.watch(selectedCenterProvider)!; // safe to use now
    final destination =
        ref.watch(selectedDestinationProvider)!; // safe to use now

    final distanceAsync = ref.watch(
      distanceProvider(DistanceIds(center.id, destination.id)),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Order Summary',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange.shade700,
      ),
      body: distanceAsync.when(
        data: (distance) {
          final shippingFee = distance * 50;
          const serviceFeePercent = 0.0;
          const vatPercent = 0.0;

          final serviceFee = subtotalPrice * serviceFeePercent;
          final vat = subtotalPrice * vatPercent;
          final totalPrice = subtotalPrice + serviceFee + vat + shippingFee;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Summary Card
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSummaryRow(
                          'Subtotal',
                          'Br ${subtotalPrice.toStringAsFixed(1)}',
                        ),
                        _buildSummaryRow(
                          'Service fee',
                          '${serviceFee.toStringAsFixed(0)} Br',
                        ),
                        _buildSummaryRow(
                          'VAT',
                          '${vat.toStringAsFixed(0)} (0%)',
                        ),
                        _buildSummaryRow(
                          'Shipping',
                          '${shippingFee.toStringAsFixed(2)} Br',
                        ),
                        const Divider(height: 30, thickness: 1.2),
                        _buildSummaryRow(
                          'Total',
                          'Br ${totalPrice.toStringAsFixed(1)}',
                          isBold: true,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Distance: ${distance.toStringAsFixed(2)} km",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Transfer Info
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                    const ClipboardData(text: "1000179236994"),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Center(
                                        child: Text(
                                          "Account number copied",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                child: Row(
                                  children: const [
                                    Text(
                                      "Transfer to: ",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '1000179236994',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Owner: Kaytros Gecho Arka',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Click on check out button below to upload screenshot of your transaction for order approval.',
                  style: TextStyle(fontSize: 14),
                ),
                const Spacer(),
                // Checkout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showPaymentDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Check Out',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(" Error calculating distance: $e")),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
