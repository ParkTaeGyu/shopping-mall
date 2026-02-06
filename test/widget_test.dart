// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:copang/src/app.dart';
import 'package:copang/src/features/auth/domain/app_user.dart';
import 'package:copang/src/features/auth/presentation/auth_controller.dart';
import 'package:copang/src/features/products/domain/product.dart';
import 'package:copang/src/features/products/data/supabase_product_repository.dart';
import 'package:copang/src/features/orders/domain/order.dart';
import 'package:copang/src/features/orders/data/supabase_order_repository.dart';
import 'package:copang/src/features/users/domain/user_profile.dart';
import 'package:copang/src/features/users/data/supabase_user_repository.dart';

// Mock AuthController
class MockAuthController extends StateNotifier<AppUser?> implements AuthController {
  MockAuthController() : super(null);

  @override
  Future<bool> login({required String email, required String password}) async {
    if (email == 'test1@example.com' && password == '1111') {
      state = const AppUser(uid: 'user_uid', email: 'test1@example.com', role: UserRole.user);
      return true;
    }
    if (email == 'admin@example.com' && password == '1111') {
      state = const AppUser(uid: 'admin_uid', email: 'admin@example.com', role: UserRole.admin);
      return true;
    }
    return false;
  }

  @override
  Future<bool> signUp({required String email, required String password}) async {
    return true; // Mock success
  }

  @override
  Future<void> logout() async {
    state = null;
  }
}

// Mock Product Repository
class MockProductRepository implements SupabaseProductRepository {
  final List<Product> _products = [
    const Product(
      id: '1',
      title: 'Premium Hair Shampoo',
      description: 'Desc',
      price: 25.0,
      imageUrl: '',
      category: 'Hair',
    ),
  ];

  @override
  Future<List<Product>> getProducts() async {
    return _products;
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    return _products.where((p) => p.category == category).toList();
  }

  @override
  Future<Product?> getProduct(String id) async {
    return _products.firstWhere((p) => p.id == id, orElse: () => _products.first);
  }

  @override
  Future<void> addProduct(Product product) async {
    _products.add(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
  }

  @override
  Future<void> deleteProduct(String id) async {
  }
  
  @override
  // ignore: unused_element
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Mock Order Repository
class MockOrderRepository implements SupabaseOrderRepository {
  final List<Order> _orders = [
    Order(
      id: '101',
      userId: 'user_1',
      totalAmount: 50.0,
      status: OrderStatus.pending,
      createdAt: DateTime(2023),
      items: [],
    ),
  ];

  @override
  Future<List<Order>> getOrders() async {
    return _orders;
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
  }

  @override
  // ignore: unused_element
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Mock User Repository
class MockUserRepository implements SupabaseUserRepository {
  final List<UserProfile> _users = [
    UserProfile(
      id: 'user_uid',
      email: 'test1@test.com',
      role: UserRole.user,
      createdAt: DateTime(2023),
    ),
  ];

  @override
  Future<List<UserProfile>> getProfiles() async {
    return _users;
  }

  @override
  Future<void> updateUserRole(String userId, UserRole role) async {
  }

  @override
  // ignore: unused_element
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('App flow test with mocks', (WidgetTester tester) async {
    final mockAuth = MockAuthController();
    final mockRepo = MockProductRepository();
    final mockOrderRepo = MockOrderRepository();
    final mockUserRepo = MockUserRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith((ref) => mockAuth),
          supabaseProductRepositoryProvider.overrideWithValue(mockRepo),
          supabaseOrderRepositoryProvider.overrideWithValue(mockOrderRepo),
          supabaseUserRepositoryProvider.overrideWithValue(mockUserRepo),
        ],
        child: const MyApp(),
      ),
    );

    // Verify Login Screen
    expect(find.text('로그인'), findsAtLeastNWidgets(1));

    // Login as User
    await tester.enterText(find.byType(TextFormField).first, 'test1@example.com');
    await tester.enterText(find.byType(TextFormField).last, '1111');
    await tester.tap(find.widgetWithText(ElevatedButton, '로그인'));
    await tester.pumpAndSettle();

    // Verify Home Screen UI
    expect(find.text('카테고리별 쇼핑'), findsOneWidget);
  });

  testWidgets('Admin flow test', (WidgetTester tester) async {
    final mockAuth = MockAuthController();
    final mockRepo = MockProductRepository();
    final mockOrderRepo = MockOrderRepository();
    final mockUserRepo = MockUserRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith((ref) => mockAuth),
          supabaseProductRepositoryProvider.overrideWithValue(mockRepo),
          supabaseOrderRepositoryProvider.overrideWithValue(mockOrderRepo),
          supabaseUserRepositoryProvider.overrideWithValue(mockUserRepo),
        ],
        child: const MyApp(),
      ),
    );

    // Login as Admin
    await tester.enterText(find.byType(TextFormField).first, 'admin@example.com');
    await tester.enterText(find.byType(TextFormField).last, '1111');
    await tester.tap(find.widgetWithText(ElevatedButton, '로그인'));
    await tester.pumpAndSettle();

    // Verify Admin Dashboard
    expect(find.text('관리자 대시보드'), findsOneWidget);

    // Navigate to Users
    await tester.tap(find.byIcon(Icons.people));
    await tester.pumpAndSettle();

    // Verify User List
    expect(find.text('사용자 관리'), findsOneWidget);
    expect(find.text('test1@test.com'), findsOneWidget);
  });
}
