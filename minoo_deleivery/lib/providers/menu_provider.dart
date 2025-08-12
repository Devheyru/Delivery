import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:minoo_deleivery/utils/menu_item.dart';
import '../services/api_service.dart';
import '../repositories/menu_repository.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final menuRepositoryProvider = Provider<MenuRepository>(
  (ref) => MenuRepository(ref.read(apiServiceProvider)),
);

class MenuListNotifier extends AsyncNotifier<List<MenuItem>> {
  @override
  Future<List<MenuItem>> build() {
    return ref.read(menuRepositoryProvider).fetchMenus();
  }

  Future<void> refreshMenus() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(menuRepositoryProvider).fetchMenus(),
    );
  }
}

final menuListProvider =
    AsyncNotifierProvider<MenuListNotifier, List<MenuItem>>(
      MenuListNotifier.new,
    );
