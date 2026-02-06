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

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

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
  });
}
