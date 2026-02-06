import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../orders/domain/order.dart' as app_order; // Alias to avoid conflict if any
import '../../orders/data/supabase_order_repository.dart';

class AdminOrderListScreen extends ConsumerWidget {
  const AdminOrderListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(adminOrdersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('주문 관리')),
      body: ordersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('주문이 없습니다'));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text('주문 #${order.id}'),
                  subtitle: Text(
                    '${order.createdAt.toString().split('.')[0]} - \$${order.totalAmount}\n상태: ${order.status.label}',
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Text('상태 변경: '),
                          const SizedBox(width: 10),
                          DropdownButton<app_order.OrderStatus>(
                            value: order.status,
                            onChanged: (newStatus) async {
                              if (newStatus != null) {
                                await ref.read(supabaseOrderRepositoryProvider).updateOrderStatus(order.id, newStatus);
                                ref.invalidate(adminOrdersProvider);
                              }
                            },
                            items: app_order.OrderStatus.values.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status.label),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('오류: $err')),
      ),
    );
  }
}
