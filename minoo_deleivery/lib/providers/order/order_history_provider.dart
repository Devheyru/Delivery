import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minoo_deleivery/models/order_model.dart';
import 'package:minoo_deleivery/providers/order/order_provider.dart';

/// Provider for loading the current user's order history.
final orderHistoryProvider = FutureProvider<List<Order>>((ref) async {
  final repo = ref.watch(orderRepositoryProvider);
  final prefs = await SharedPreferences.getInstance();
  String userId = prefs.getString('user_id') ?? '';
  if (userId.isEmpty) {
    userId = 'guest_${DateTime.now().millisecondsSinceEpoch % 10000}';
    await prefs.setString('user_id', userId);
  }
  return repo.fetchOrders(userId);
});
