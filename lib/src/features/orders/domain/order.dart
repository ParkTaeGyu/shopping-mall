import '../../cart/domain/cart_item.dart';

enum OrderStatus {
  pending,
  shipped,
  delivered,
  cancelled;

  String get label => name.toUpperCase();
}

class Order {
  final String id;
  final String userId;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;
  final List<CartItem> items;

  const Order({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.items,
  });
}
