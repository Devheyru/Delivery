import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://minoodelivery.com';

  Future<List<dynamic>> getMenusRaw() async {
    final uri = Uri.parse('$baseUrl/menus');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) return decoded;
      if (decoded is Map && decoded['data'] is List) return decoded['data'];
      throw Exception('Unexpected JSON format');
    } else {
      throw Exception('Failed to load menus');
    }
  }
}
