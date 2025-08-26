import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:minoo_deleivery/providers/address/address_providers.dart';

Future<void> uploadSelectedAddress(WidgetRef ref) async {
  final selectedCenter = ref.read(selectedCenterProvider);
  final selectedDestination = ref.read(selectedDestinationProvider);

  if (selectedCenter == null) {
    throw Exception("No delivery center selected");
  }
  if (selectedDestination == null) {
    throw Exception("No destination selected");
  }

  // Fetch distance between center + destination
  final distance = await ref.read(
    distanceProvider({
      "center": selectedCenter.id,
      "destination": selectedDestination.id,
    }).future,
  );

  final response = await http.post(
    Uri.parse("https://example.com/api/submit_address"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "center_id": selectedCenter.id,
      "center_name": selectedCenter.name,
      "destination_id": selectedDestination.id,
      "destination_name": selectedDestination.name,
      "distance": distance,
    }),
  );

  if (response.statusCode == 200) {
    print("✅ Address & destination uploaded successfully!");

    // clear saved after checkout
    ref.read(selectedCenterProvider.notifier).state = null;
    ref.read(selectedDestinationProvider.notifier).state = null;
  }
}
