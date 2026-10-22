import 'package:flutter/foundation.dart';

/// Centralized API configuration.
/// On Web in debug/local development, requests route through the local CORS proxy (port 5050).
/// On mobile devices (Android / iOS) or production, requests go directly to the live backend.
class ApiConfig {
  ApiConfig._();

  static const String liveBaseUrl = 'https://minoodelivery.havanacademy.com';

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://127.0.0.1:5050';
    }
    return liveBaseUrl;
  }

  // Derived endpoints
  static String get menusUrl => '$baseUrl/menus';
  static String get menuItemsUrl => '$baseUrl/menu-items';
  static String get deliveryZonesUrl => '$baseUrl/delivery-zones';
  static String get ordersUrl => '$baseUrl/orders';

  static String destinationsUrl(int centerId) =>
      '$deliveryZonesUrl/destinations/$centerId';

  static String distanceUrl(int centerId, int destinationId) =>
      '$deliveryZonesUrl/distance/$centerId/$destinationId';

  static String imageUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    if (path.startsWith('/')) return '$baseUrl$path';
    return '$baseUrl/$path';
  }
}

