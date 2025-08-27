import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minoo_deleivery/providers/address/address_providers.dart';

class PricedetailsPage extends ConsumerWidget {
  const PricedetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final center = ref.watch(selectedCenterProvider);
    final destination = ref.watch(selectedDestinationProvider);

    if (center == null || destination == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text("Please select both Delivery center & destination"),
        ),
      );
    }

    // ✅ use DistanceIds (not Map)
    final distanceAsync = ref.watch(
      distanceProvider(DistanceIds(center.id, destination.id)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Price Details")),
      body: Center(
        child: distanceAsync.when(
          data: (distance) {
            return Text(
              "Distance value: ${distance.toStringAsFixed(2)} km",
              style: const TextStyle(fontSize: 18),
            );
          },
          loading:
              () => const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text("Calculating distance..."),
                ],
              ),
          error: (e, _) => Text("❌ Error: $e"),
        ),
      ),
    );
  }
}
