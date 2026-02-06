import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/auth/domain/app_user.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/products/presentation/user/user_home_screen.dart';
import '../features/admin_dashboard/presentation/admin_dashboard_screen.dart';
import '../features/admin_dashboard/presentation/admin_product_edit_screen.dart';
import '../features/admin_dashboard/presentation/admin_order_list_screen.dart';
import '../features/admin_dashboard/presentation/admin_user_list_screen.dart';
import '../features/products/presentation/user/categories_screen.dart';
import '../features/cart/presentation/cart_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/products/presentation/user/product_list_screen.dart';
import '../features/products/presentation/user/product_detail_screen.dart';
import 'scaffold_with_nav_bar.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: ValueNotifier(authState), // Re-evaluate logic when User changes
    redirect: (context, state) {
      final isLoggedIn = authState != null;
      final isLoggingIn = state.uri.toString() == '/login';

      if (!isLoggedIn && !isLoggingIn) return '/login';

      if (isLoggedIn) {
        final isAdmin = authState.role == UserRole.admin;
        final isGoingToAdmin = state.uri.toString().startsWith('/admin');

        // Redirect Admin to /admin if not already there
        if (isAdmin && !isGoingToAdmin) return '/admin/dashboard';

        // Redirect User to / if trying to access admin
        if (!isAdmin && isGoingToAdmin) return '/';

        // Redirect logged in user from login page to home
        if (isLoggingIn) {
             return isAdmin ? '/admin/dashboard' : '/';
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
        routes: [
           GoRoute(
            path: 'product/add',
            builder: (context, state) => const AdminProductEditScreen(),
          ),
          GoRoute(
            path: 'product/edit/:id',
            builder: (context, state) => AdminProductEditScreen(productId: state.pathParameters['id']),
          ),
        ],
      ),
      GoRoute(
        path: '/admin/orders',
        builder: (context, state) => const AdminOrderListScreen(),
      ),
      GoRoute(
        path: '/admin/users',
        builder: (context, state) => const AdminUserListScreen(),
      ),
      // User Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const UserHomeScreen(),
                routes: [
                  GoRoute(
                    path: 'category/:id',
                    builder: (context, state) {
                      final categoryId = state.pathParameters['id']!;
                      return ProductListScreen(category: categoryId);
                    },
                  ),
                  GoRoute(
                    path: 'product/:id',
                    builder: (context, state) {
                      final productId = state.pathParameters['id']!;
                      return ProductDetailScreen(productId: productId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/categories',
                builder: (context, state) => const CategoriesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
