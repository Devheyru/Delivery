import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:minoo_deleivery/config/api_config.dart';

class ApiService {
  final http.Client? _client;

  ApiService({http.Client? client}) : _client = client;

  Future<List<dynamic>> getMenusRaw() async {
    try {
      final uri = Uri.parse(ApiConfig.menusUrl);
      final client = _client ?? http.Client();
      final response = await client
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is List) return decoded;
        if (decoded is Map && decoded['data'] is List) return decoded['data'];
        throw Exception('Unexpected JSON format');
      } else {
        throw Exception('Failed to load menus');
      }
    } on SocketException {
      // Backend unreachable → return demo data
      return _demoMenus();
    } on http.ClientException {
      return _demoMenus();
    } on TimeoutException {
      return _demoMenus();
    }
  }

  /// Demo menu data used when the backend at [ApiConfig.baseUrl] is not reachable.
  /// Remove this once the real server is deployed.
  static List<Map<String, dynamic>> _demoMenus() {
    return [
      {
        'id': '1',
        'vendor_id': '1',
        'public_id': 'demo-1',
        'menu_name': 'Special Burger',
        'menu_description':
            'A juicy beef burger with fresh lettuce, tomato, cheese, and our secret Minoo sauce. Served with golden fries.',
        'menu_price': '250.00',
        'menu_img': '',
        'menu_category': 'Bakeries',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': '2',
        'vendor_id': '1',
        'public_id': 'demo-2',
        'menu_name': 'Margherita Pizza',
        'menu_description':
            'Classic Italian pizza with fresh mozzarella, basil, and rich tomato sauce on a thin crispy crust.',
        'menu_price': '350.00',
        'menu_img': '',
        'menu_category': 'Bakeries',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': '3',
        'vendor_id': '2',
        'public_id': 'demo-3',
        'menu_name': 'Chicken Shawarma',
        'menu_description':
            'Tender marinated chicken wrapped in warm pita bread with garlic sauce, pickles, and fresh vegetables.',
        'menu_price': '180.00',
        'menu_img': '',
        'menu_category': 'Bakeries',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': '4',
        'vendor_id': '2',
        'public_id': 'demo-4',
        'menu_name': 'Fresh Mango Juice',
        'menu_description':
            'Freshly squeezed mango juice made from ripe Ethiopian mangoes. No added sugar.',
        'menu_price': '80.00',
        'menu_img': '',
        'menu_category': 'Fruits',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': '5',
        'vendor_id': '3',
        'public_id': 'demo-5',
        'menu_name': 'Avocado Smoothie',
        'menu_description':
            'Creamy avocado smoothie blended with milk, honey, and a touch of lime. Healthy and delicious.',
        'menu_price': '100.00',
        'menu_img': '',
        'menu_category': 'Fruits',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': '6',
        'vendor_id': '3',
        'public_id': 'demo-6',
        'menu_name': 'Tibs Firfir',
        'menu_description':
            'Traditional Ethiopian dish with sautéed beef tibs mixed with injera pieces and spicy berbere sauce.',
        'menu_price': '220.00',
        'menu_img': '',
        'menu_category': 'Hotels',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': '7',
        'vendor_id': '4',
        'public_id': 'demo-7',
        'menu_name': 'Kitfo Special',
        'menu_description':
            'Premium minced raw beef seasoned with mitmita and niter kibbeh, served with fresh injera and ayib.',
        'menu_price': '300.00',
        'menu_img': '',
        'menu_category': 'Hotels',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
      {
        'id': '8',
        'vendor_id': '4',
        'public_id': 'demo-8',
        'menu_name': 'Banana Basket',
        'menu_description':
            'A basket of fresh ripe bananas, perfect for a healthy snack. Locally sourced from Jimma farms.',
        'menu_price': '60.00',
        'menu_img': '',
        'menu_category': 'Fruits',
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      },
    ];
  }
}
