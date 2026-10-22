import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:minoo_deleivery/config/api_config.dart';
import 'package:minoo_deleivery/models/delivery_center_model.dart';
import 'package:minoo_deleivery/models/destination_address.dart';

// --- Immutable class for distance keys ---
class DistanceIds {
  final int centerId;
  final int destinationId;

  const DistanceIds(this.centerId, this.destinationId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DistanceIds &&
          runtimeType == other.runtimeType &&
          centerId == other.centerId &&
          destinationId == other.destinationId;

  @override
  int get hashCode => centerId.hashCode ^ destinationId.hashCode;
}

// 1. Fetch all delivery centers
final deliveryCentersProvider = FutureProvider<List<DeliveryCenter>>((
  ref,
) async {
  try {
    final response = await http
        .get(Uri.parse(ApiConfig.deliveryZonesUrl))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => DeliveryCenter.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch delivery centers: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("[address_providers] Failed to fetch delivery centers: $e");
    return _demoDeliveryCenters();
  }
});

// Selected center
final selectedCenterProvider = StateProvider<DeliveryCenter?>((ref) => null);

// 2. Fetch destinations for selected center
final destinationsProvider = FutureProvider.family<List<Destination>, int>((
  ref,
  centerId,
) async {
  try {
    final response = await http
        .get(Uri.parse(ApiConfig.destinationsUrl(centerId)))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Destination.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch destinations: ${response.statusCode}");
    }
  } catch (e) {
    debugPrint("[address_providers] Failed to fetch destinations for center $centerId: $e");
    return _demoDestinations(centerId);
  }
});

// Selected destination
final selectedDestinationProvider = StateProvider<Destination?>((ref) => null);

// 3. Fetch distance between center + destination
final distanceProvider = FutureProvider.family<double, DistanceIds>((
  ref,
  ids,
) async {
  try {
    final url = ApiConfig.distanceUrl(ids.centerId, ids.destinationId);

    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Ensure trimming & parsing safely
      final distanceString = data['distance']?.toString().trim() ?? '';
      final distance = double.tryParse(distanceString) ?? 5.0;
      return distance;
    } else {
      throw Exception("Failed to fetch distance: ${response.statusCode}");
    }
  } catch (e) {
    // Return a demo distance when server is unreachable
    return 5.0;
  }
});

// ── Demo fallback data ──────────────────────────────────────────────────────

List<DeliveryCenter> _demoDeliveryCenters() {
  return [
    DeliveryCenter.fromJson({
      'id': 1,
      'name': 'Bole Delivery Center',
      'slug': 'bole',
    }),
    DeliveryCenter.fromJson({
      'id': 2,
      'name': 'Piassa Delivery Center',
      'slug': 'piassa',
    }),
    DeliveryCenter.fromJson({
      'id': 3,
      'name': 'Megenagna Delivery Center',
      'slug': 'megenagna',
    }),
  ];
}

List<Destination> _demoDestinations(int centerId) {
  return [
    Destination.fromJson({
      'id': 1,
      'delivery_center_id': centerId,
      'name': 'Home',
      'slug': 'home',
      'distance': '5.0',
    }),
    Destination.fromJson({
      'id': 2,
      'delivery_center_id': centerId,
      'name': 'Office',
      'slug': 'office',
      'distance': '8.0',
    }),
  ];
}

