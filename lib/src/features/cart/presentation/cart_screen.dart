import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cart/application/cart_service.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartServiceProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('장바구니')),
      body: cartItems.isEmpty
          ? const Center(child: Text('장바구니가 비어있습니다'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                        title: Text(item.product.title),
                        subtitle: Text('\$${item.product.price} x ${item.quantity}개'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (item.quantity > 1) {
                                  ref.read(cartServiceProvider.notifier).updateQuantity(item.product.id, item.quantity - 1);
                                } else {
                                  ref.read(cartServiceProvider.notifier).removeItem(item.product.id);
                                }
                              },
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                ref.read(cartServiceProvider.notifier).updateQuantity(item.product.id, item.quantity + 1);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('합계', style: TextStyle(color: Colors.grey)),
                          Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implement Checkout
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('결제 기능은 아직 준비 중입니다.')),
                          );
                        },
                        child: const Text('결제하기'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
