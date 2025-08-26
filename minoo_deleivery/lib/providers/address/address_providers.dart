import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:minoo_deleivery/models/delivery_center_model.dart';
import 'package:minoo_deleivery/models/destination_address.dart';

const String baseUrl = "https://minoodelivery.com/delivery-zones";

// 1. Fetch all delivery centers
final deliveryCentersProvider = FutureProvider<List<DeliveryCenter>>((
  ref,
) async {
  final response = await http.get(Uri.parse(baseUrl));

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((e) => DeliveryCenter.fromJson(e)).toList();
  } else {
    throw Exception("Failed to fetch delivery centers");
  }
});

// Selected center
final selectedCenterProvider = StateProvider<DeliveryCenter?>((ref) => null);

// 2. Fetch destinations for selected center
final destinationsProvider = FutureProvider.family<List<Destination>, int>((
  ref,
  centerId,
) async {
  final response = await http.get(Uri.parse("$baseUrl/destinations/$centerId"));

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((e) => Destination.fromJson(e)).toList();
  } else {
    throw Exception("Failed to fetch destinations");
  }
});

// Selected destination
final selectedDestinationProvider = StateProvider<Destination?>((ref) => null);

// 3. Fetch distance between center + destination
final distanceProvider = FutureProvider.family<double, Map<String, int>>((
  ref,
  ids,
) async {
  final centerId = ids['center']!;
  final destId = ids['destination']!;

  final response = await http.get(
    Uri.parse("$baseUrl/distance/$centerId/$destId"),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return (data['distance'] as num).toDouble();
  } else {
    throw Exception("Failed to fetch distance");
  }
});
