import '../../cart/domain/cart_item.dart';

enum OrderStatus {
  pending,
  shipped,
  delivered,
  cancelled;

  String get label {
    switch (this) {
      case OrderStatus.pending:
        return '대기';
      case OrderStatus.shipped:
        return '배송 중';
      case OrderStatus.delivered:
        return '배송 완료';
      case OrderStatus.cancelled:
        return '취소';
    }
  }
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
