import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/supabase_product_repository.dart';
import '../../../cart/application/cart_service.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productProvider(productId));

    return Scaffold(
      body: productAsync.when(
        data: (product) {
          if (product == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const Center(child: Text('상품을 찾을 수 없습니다')),
            );
          }
          return Scaffold(
            appBar: AppBar(title: Text(product.title)),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 300,
                          color: Colors.grey[200],
                          child: product.imageUrl.startsWith('http')
                              ? Image.network(product.imageUrl, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.error))
                              : const Icon(Icons.image, size: 100, color: Colors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${product.price}',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Text(product.description),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(cartServiceProvider.notifier).addItem(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${product.title} 장바구니에 담겼습니다')),
                        );
                      },
                      child: const Text('장바구니 담기'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()),
        ),
        error: (err, stack) => Scaffold(
          appBar: AppBar(),
          body: Center(child: Text('오류: $err')),
        ),
      ),
    );
  }
}
