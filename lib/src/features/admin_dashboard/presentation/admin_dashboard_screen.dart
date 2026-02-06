import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../products/data/supabase_product_repository.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We can reuse productsListProvider('all') to fetch all products
    final productsAsync = ref.watch(productsListProvider('all'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('관리자 대시보드'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: '주문 관리',
            onPressed: () => context.go('/admin/orders'),
          ),
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: '사용자 관리',
            onPressed: () => context.go('/admin/users'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: productsAsync.when(
        data: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              leading: Container(
                width: 50,
                height: 50,
                color: Colors.grey[200],
                child: product.imageUrl.startsWith('http')
                    ? Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                      )
                    : const Icon(Icons.image, color: Colors.grey),
              ),
              title: Text(product.title),
              subtitle: Text('\$${product.price}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => context.go('/admin/dashboard/product/edit/${product.id}'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await ref.read(supabaseProductRepositoryProvider).deleteProduct(product.id);
                      // Invalidate and refresh the provider
                      ref.invalidate(productsListProvider('all'));
                    },
                  ),
                ],
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('오류: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/admin/dashboard/product/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
