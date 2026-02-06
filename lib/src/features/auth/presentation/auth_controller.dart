import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/app_user.dart';
import '../data/user_mapper.dart';

class AuthController extends StateNotifier<AppUser?> {
  AuthController() : super(null) {
    _init();
  }

  void _init() {
    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        state = session.user.toAppUser();
      } else {
        state = null;
      }
    });
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AppUser?>((ref) {
  return AuthController();
});
