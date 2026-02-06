import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/product.dart';

class FakeProductRepository {
  final List<Product> _products = [
    const Product(
      id: '1',
      title: 'Premium Hair Shampoo',
      description: 'Revitalize your hair with this premium shampoo.',
      price: 25.0,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Hair',
    ),
    const Product(
      id: '2',
      title: 'Aloe Vera Skin Gel',
      description: 'Soothing gel for all skin types.',
      price: 15.0,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Skin',
    ),
    const Product(
      id: '3',
      title: 'Matte Lipstick Red',
      description: 'Long-lasting matte lipstick.',
      price: 20.0,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Makeup',
    ),
    const Product(
      id: '4',
      title: 'Nail Polish Remover',
      description: 'Acetone-free nail polish remover.',
      price: 8.0,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Nail',
    ),
  ];

  List<Product> getProducts() {
    return _products;
  }

  Product? getProduct(String id) {
    return _products.firstWhere((product) => product.id == id, orElse: () => throw Exception('Product not found'));
  }
  
  List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }
}

final productRepositoryProvider = Provider<FakeProductRepository>((ref) {
  return FakeProductRepository();
});

final productsListProvider = Provider<List<Product>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
});

final productProvider = Provider.family<Product?, String>((ref, id) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProduct(id);
});

final categoryProductsProvider = Provider.family<List<Product>, String>((ref, category) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductsByCategory(category);
});
