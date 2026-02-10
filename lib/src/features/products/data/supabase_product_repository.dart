import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/api_client.dart';
import '../domain/product.dart';

class SupabaseProductRepository {
  final Dio _dio;

  SupabaseProductRepository(this._dio);

  Future<List<Product>> getProducts() async {
    final response = await _dio.get('/api/products');
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => Product(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/150',
      category: json['category'],
    )).toList();
  }

  Future<Product?> getProduct(String id) async {
    final response = await _dio.get('/api/products/$id');
    if (response.statusCode == 404) return null;
    final json = response.data as Map<String, dynamic>;
    return Product(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/150',
      category: json['category'],
    );
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final response = await _dio.get('/api/products', queryParameters: {
      'category': category,
    });
    final List<dynamic> data = response.data as List<dynamic>;
    return data.map((json) => Product(
      id: json['id'].toString(),
      title: json['title'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/150',
      category: json['category'],
    )).toList();
  }

  Future<void> addProduct(Product product) async {
    await _dio.post('/api/admin/products', data: {
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'category': product.category,
    });
  }

  Future<void> updateProduct(Product product) async {
    await _dio.put('/api/admin/products/${product.id}', data: {
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'category': product.category,
    });
  }

  Future<void> deleteProduct(String id) async {
    await _dio.delete('/api/admin/products/$id');
  }
}

final supabaseProductRepositoryProvider = Provider<SupabaseProductRepository>((ref) {
  return SupabaseProductRepository(ref.watch(dioProvider));
});

final productsListProvider = FutureProvider.family<List<Product>, String>((ref, category) {
  final repository = ref.watch(supabaseProductRepositoryProvider);
  if (category == 'all') {
    return repository.getProducts();
  } else {
    return repository.getProductsByCategory(category);
  }
});

final productProvider = FutureProvider.family<Product?, String>((ref, id) {
  final repository = ref.watch(supabaseProductRepositoryProvider);
  return repository.getProduct(id);
});
