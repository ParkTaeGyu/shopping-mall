import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/order.dart';
import '../../cart/domain/cart_item.dart';
import '../../products/domain/product.dart';

class SupabaseOrderRepository {
  final SupabaseClient _client;

  SupabaseOrderRepository(this._client);

  Future<List<Order>> getOrders() async {
    // In a real app, we would join with order_items table.
    // For simplicity/mock, we might fetch from a single 'orders' table if it stores JSON,
    // or just return dummy data since DB schema might not be ready.
    // Let's assume a simple schema or return mocked data for now if DB isn't set up for orders yet.
    // actually, let's implement the structure assuming 'orders' table exists.
    
    try {
      final response = await _client.from('orders').select().order('created_at', ascending: false);
      final data = response as List<dynamic>;
      return data.map((json) => _fromJson(json)).toList();
    } catch (e) {
      // Fallback for demo if table doesn't exist
      return [];
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _client.from('orders').update({'status': status.name}).eq('id', orderId);
  }

  // Helper to parse JSON (simplified for now)
  Order _fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString(),
      userId: json['user_id'] ?? 'unknown',
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: OrderStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => OrderStatus.pending),
      createdAt: DateTime.parse(json['created_at']),
      items: [], // Populating items would require a join or JSON parsing
    );
  }
}

final supabaseOrderRepositoryProvider = Provider<SupabaseOrderRepository>((ref) {
  return SupabaseOrderRepository(Supabase.instance.client);
});

final adminOrdersProvider = FutureProvider<List<Order>>((ref) {
  return ref.watch(supabaseOrderRepositoryProvider).getOrders();
});
