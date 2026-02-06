import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../products/domain/product.dart';
import '../domain/cart_item.dart';

class CartService extends StateNotifier<List<CartItem>> {
  CartService() : super([]);

  void addItem(Product product) {
    if (state.any((item) => item.product.id == product.id)) {
      // Increment quantity if already exists
      state = [
        for (final item in state)
          if (item.product.id == product.id)
            item.copyWith(quantity: item.quantity + 1)
          else
            item
      ];
    } else {
      // Add new item
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }

  void removeItem(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void updateQuantity(String productId, int quantity) {
    state = [
      for (final item in state)
        if (item.product.id == productId)
          item.copyWith(quantity: quantity)
        else
          item
    ];
  }

  void clearCart() {
    state = [];
  }
}

final cartServiceProvider = StateNotifierProvider<CartService, List<CartItem>>((ref) {
  return CartService();
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartServiceProvider);
  return cart.fold(0, (total, item) => total + (item.product.price * item.quantity));
});
