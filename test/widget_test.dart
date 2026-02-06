// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:copang/src/app.dart';
import 'package:copang/src/features/auth/domain/app_user.dart';
import 'package:copang/src/features/auth/presentation/auth_controller.dart';
import 'package:copang/src/features/products/domain/product.dart';
import 'package:copang/src/features/products/data/supabase_product_repository.dart';

// Mock AuthController
class MockAuthController extends StateNotifier<AppUser?> implements AuthController {
  MockAuthController() : super(null);

  @override
  Future<bool> login({required String email, required String password}) async {
    if (email == 'test1' && password == '1111') {
      state = const AppUser(uid: 'user_uid', email: 'test1', role: UserRole.user);
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
  @override
  Future<List<Product>> getProducts() async {
    return [
      const Product(
        id: '1',
        title: 'Premium Hair Shampoo',
        description: 'Desc',
        price: 25.0,
        imageUrl: '',
        category: 'Hair',
      ),
    ];
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    return [
      const Product(
        id: '1',
        title: 'Premium Hair Shampoo',
        description: 'Desc',
        price: 25.0,
        imageUrl: '',
        category: 'Hair',
      ),
    ];
  }

  @override
  Future<Product?> getProduct(String id) async {
    return const Product(
      id: '1',
      title: 'Premium Hair Shampoo',
      description: 'Desc',
      price: 25.0,
      imageUrl: '',
      category: 'Hair',
    );
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
