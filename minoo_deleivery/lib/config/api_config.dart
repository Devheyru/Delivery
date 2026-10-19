/// Centralized API configuration.
/// Change [baseUrl] here once your backend is deployed — every file reads from this single source.
class ApiConfig {
  ApiConfig._();

  /// ──────────────────────────────────────────────
  /// 🔧  Live backend host
  /// ──────────────────────────────────────────────
  static const String baseUrl = 'https://minoodelivery.havanacademy.com';

  // Derived endpoints
  static const String menusUrl = '$baseUrl/menus';
  static const String menuItemsUrl = '$baseUrl/menu-items';
  static const String deliveryZonesUrl = '$baseUrl/delivery-zones';
  static const String ordersUrl = '$baseUrl/orders';

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
