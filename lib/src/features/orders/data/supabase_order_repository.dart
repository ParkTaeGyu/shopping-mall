import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/api_client.dart';
import '../domain/order.dart';

class SupabaseOrderRepository {
  final Dio _dio;

  SupabaseOrderRepository(this._dio);

  Future<List<Order>> getOrders() async {
    try {
      final response = await _dio.get('/api/admin/orders');
      final data = response.data as List<dynamic>;
      return data.map((json) => _fromJson(json)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _dio.put('/api/admin/orders/$orderId/status', data: {
      'status': status.name,
    });
  }

  Order _fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      userId: json['user_id'] ?? 'unknown',
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: OrderStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => OrderStatus.pending),
      createdAt: DateTime.parse(json['created_at']),
      items: [],
    );
  }
}

final supabaseOrderRepositoryProvider = Provider<SupabaseOrderRepository>((ref) {
  return SupabaseOrderRepository(ref.watch(dioProvider));
});

final adminOrdersProvider = FutureProvider<List<Order>>((ref) {
  return ref.watch(supabaseOrderRepositoryProvider).getOrders();
});
