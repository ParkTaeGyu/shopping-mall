import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/product.dart';

class FakeProductRepository {
  final List<Product> _products = [
    const Product(
      id: '1',
      title: '프리미엄 헤어 샴푸',
      description: '풍성하고 윤기 있는 모발을 위한 프리미엄 샴푸.',
      price: 25.0,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Hair',
    ),
    const Product(
      id: '2',
      title: '알로에 스킨 젤',
      description: '모든 피부 타입에 부드럽게 흡수되는 진정 젤.',
      price: 15.0,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Skin',
    ),
    const Product(
      id: '3',
      title: '매트 립스틱 레드',
      description: '오래 지속되는 선명한 매트 립스틱.',
      price: 20.0,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Makeup',
    ),
    const Product(
      id: '4',
      title: '네일 폴리시 리무버',
      description: '아세톤 프리, 손톱에 부담이 적은 리무버.',
      price: 8.0,
      imageUrl: 'https://via.placeholder.com/150',
      category: 'Nail',
    ),
  ];

  List<Product> getProducts() {
    return _products;
  }

  Product? getProduct(String id) {
    return _products.firstWhere((product) => product.id == id, orElse: () => throw Exception('상품을 찾을 수 없습니다'));
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
