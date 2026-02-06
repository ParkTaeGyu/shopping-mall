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

// Mock AuthController
class MockAuthController extends StateNotifier<AppUser?> implements AuthController {
  MockAuthController() : super(null);

  @override
  Future<bool> login({required String email, required String password}) async {
    if (email == 'test1' && password == '1111') {
      state = const AppUser(uid: 'user_uid', email: 'test1', role: UserRole.user);
      return true;
    }
    if (email == 'admin' && password == '1111') {
      state = const AppUser(uid: 'admin_uid', email: 'admin', role: UserRole.admin);
      return true;
    }
    return false;
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
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
  }
  
  @override
  // ignore: unused_element
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('App flow test with mocks', (WidgetTester tester) async {
    final mockAuth = MockAuthController();
    final mockRepo = MockProductRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith((ref) => mockAuth),
          supabaseProductRepositoryProvider.overrideWithValue(mockRepo),
        ],
        child: const MyApp(),
      ),
    );

    // Verify that the LoginScreen is displayed initially
    expect(find.text('Login'), findsAtLeastNWidgets(1));
    expect(find.byType(TextFormField), findsNWidgets(2));

    // Login as User
    await tester.enterText(find.byType(TextFormField).first, 'test1');
    await tester.enterText(find.byType(TextFormField).last, '1111');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Verify Home Screen UI
    expect(find.text('Shop by Category'), findsOneWidget);
    expect(find.text('Hair'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget); // Bottom Nav Home Icon

    // Navigate to Product List (Hair)
    await tester.tap(find.text('Hair'));
    await tester.pumpAndSettle();

    // Verify Product List Screen
    expect(find.text('Hair'), findsOneWidget); // AppBar title
    expect(find.text('Premium Hair Shampoo'), findsOneWidget); // Product Item

    // Tap on Product
    await tester.tap(find.text('Premium Hair Shampoo'));
    await tester.pumpAndSettle();

    // Verify Product Detail & Add to Cart
    expect(find.text('Premium Hair Shampoo'), findsNWidgets(2)); // AppBar + Body
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add to Cart'));
    await tester.pumpAndSettle();
    expect(find.text('Premium Hair Shampoo added to cart'), findsOneWidget);

    // Go to Cart Tab
    await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
    await tester.pumpAndSettle();

    // Verify Cart Content
    expect(find.text('Shopping Cart'), findsOneWidget);
    expect(find.text('Premium Hair Shampoo'), findsOneWidget);
    expect(find.text('\$25.00'), findsOneWidget); // Total
  });
}

// Mock Order Repository
class MockOrderRepository implements SupabaseOrderRepository {
  final List<Order> _orders = [
    Order(
      id: '101',
      userId: 'user_1',
      totalAmount: 50.0,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      items: [],
    ),
  ];

  @override
  Future<List<Order>> getOrders() async {
    return _orders;
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = Order(
        id: _orders[index].id,
        userId: _orders[index].userId,
        totalAmount: _orders[index].totalAmount,
        status: status,
        createdAt: _orders[index].createdAt,
        items: _orders[index].items,
      );
    }
  }

  // ignore: unused_element
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('App flow test with mocks', (WidgetTester tester) async {
     // ... existing test code ...
  });

  testWidgets('Admin flow test', (WidgetTester tester) async {
    final mockAuth = MockAuthController();
    final mockRepo = MockProductRepository();
    final mockOrderRepo = MockOrderRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith((ref) => mockAuth),
          supabaseProductRepositoryProvider.overrideWithValue(mockRepo),
          supabaseOrderRepositoryProvider.overrideWithValue(mockOrderRepo),
        ],
        child: const MyApp(),
      ),
    );

    // Login as Admin
    await tester.enterText(find.byType(TextFormField).first, 'admin');
    await tester.enterText(find.byType(TextFormField).last, '1111');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    // Verify Admin Dashboard
    expect(find.text('Admin Dashboard'), findsOneWidget);

    // Navigate to Orders
    await tester.tap(find.byIcon(Icons.list_alt));
    await tester.pumpAndSettle();

    // Verify Order List
    expect(find.text('Order Management'), findsOneWidget);
    expect(find.text('Order #101'), findsOneWidget);
    
    // Test Status Update (Optional, expansive interaction)
    // For now, just verifying the list page loads is good enough for flow verification.
  });
}
