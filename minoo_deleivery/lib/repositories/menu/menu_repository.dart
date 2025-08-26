import 'package:minoo_deleivery/services/menu/api_service.dart';
import 'package:minoo_deleivery/utils/menu_item.dart';

class MenuRepository {
  final ApiService apiService;
  MenuRepository(this.apiService);

  Future<List<MenuItem>> fetchMenus() async {
    final raw = await apiService.getMenusRaw();
    return raw
        .map((e) => MenuItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
