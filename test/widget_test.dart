import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shopping_mall/src/app.dart';
import 'package:shopping_mall/src/features/auth/domain/app_user.dart';
import 'package:shopping_mall/src/features/auth/presentation/auth_controller.dart';
import 'package:shopping_mall/src/features/products/domain/product.dart';
import 'package:shopping_mall/src/features/products/data/supabase_product_repository.dart';
import 'package:shopping_mall/src/features/orders/domain/order.dart';
import 'package:shopping_mall/src/features/orders/data/supabase_order_repository.dart';
import 'package:shopping_mall/src/features/users/domain/user_profile.dart';
import 'package:shopping_mall/src/features/users/data/supabase_user_repository.dart';

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
    return true;
  }

  @override
  Future<void> logout() async {
    state = null;
  }
}

class MockProductRepository implements SupabaseProductRepository {
  final List<Product> _products = [
    const Product(
      id: '1',
      title: '프리미엄 헤어 샴푸',
      description: '풍성하고 윤기 있는 모발을 위한 프리미엄 샴푸.',
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
  Future<void> updateProduct(Product product) async {}

  @override
  Future<void> deleteProduct(String id) async {}

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

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
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {}

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

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
  Future<void> updateUserRole(String userId, UserRole role) async {}

  @override
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

    expect(find.text('로그인'), findsAtLeastNWidgets(1));

    await tester.enterText(find.byType(TextFormField).first, 'test1@example.com');
    await tester.enterText(find.byType(TextFormField).last, '1111');
    await tester.tap(find.widgetWithText(ElevatedButton, '로그인'));
    await tester.pumpAndSettle();

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

    await tester.enterText(find.byType(TextFormField).first, 'admin@example.com');
    await tester.enterText(find.byType(TextFormField).last, '1111');
    await tester.tap(find.widgetWithText(ElevatedButton, '로그인'));
    await tester.pumpAndSettle();

    expect(find.text('관리자 대시보드'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.people));
    await tester.pumpAndSettle();

    expect(find.text('사용자 관리'), findsOneWidget);
    expect(find.text('test1@test.com'), findsOneWidget);
  });
}
