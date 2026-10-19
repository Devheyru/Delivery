/// Centralized API configuration.
/// Change [baseUrl] here once your backend is deployed — every file reads from this single source.
class ApiConfig {
  ApiConfig._();

  /// ──────────────────────────────────────────────
  /// 🔧  CHANGE THIS when your real server is live
  /// ──────────────────────────────────────────────
  static const String baseUrl = 'https://minoodelivery.com';

  // Derived endpoints
  static const String menusUrl = '$baseUrl/menus';
  static const String deliveryZonesUrl = '$baseUrl/delivery-zones';

  static String destinationsUrl(int centerId) =>
      '$deliveryZonesUrl/destinations/$centerId';

  static String distanceUrl(int centerId, int destinationId) =>
      '$deliveryZonesUrl/distance/$centerId/$destinationId';

  static String imageUrl(String path) {
    if (path.startsWith('http')) return path;
    if (path.startsWith('public/')) return '$baseUrl/$path';
    return '$baseUrl/public/$path';
  }
}
