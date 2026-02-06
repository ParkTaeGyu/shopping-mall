import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/product.dart';

class SupabaseProductRepository {
  final SupabaseClient _client;

  SupabaseProductRepository(this._client);

  Future<List<Product>> getProducts() async {
    final response = await _client.from('products').select();
    final List<dynamic> data = response as List<dynamic>;
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
    final response = await _client.from('products').select().eq('id', id).maybeSingle();
    if (response == null) return null;
    final json = response;
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
    final response = await _client.from('products').select().eq('category', category);
    final List<dynamic> data = response as List<dynamic>;
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
    await _client.from('products').insert({
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'image_url': product.imageUrl,
      'category': product.category,
    });
  }

  Future<void> updateProduct(Product product) async {
    await _client.from('products').update({
      'title': product.title,
      'description': product.description,
      'price': product.price,
      'image_url': product.imageUrl,
      'category': product.category,
    }).eq('id', product.id);
  }

  Future<void> deleteProduct(String id) async {
    await _client.from('products').delete().eq('id', id);
  }
}

final supabaseProductRepositoryProvider = Provider<SupabaseProductRepository>((ref) {
  return SupabaseProductRepository(Supabase.instance.client);
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
