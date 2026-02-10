import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/api_client.dart';
import '../domain/app_user.dart';
import '../data/user_mapper.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AppUser?>((ref) {
  return AuthController(ref);
});

class AuthController extends StateNotifier<AppUser?> {
  AuthController(this._ref)
      : _dio = _ref.read(dioProvider),
        super(null) {
    _init();
  }

  final Ref _ref;
  final Dio _dio;

  void _init() {
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
      final response = await _dio.post('/api/auth/login', data: {
        'email': email,
        'password': password,
      });

      final data = response.data as Map<String, dynamic>;
      final accessToken = data['access_token'] as String?;
      final refreshToken = data['refresh_token'] as String?;

      if (accessToken == null || refreshToken == null) {
        return false;
      }

      await Supabase.instance.client.auth.setSession(accessToken, refreshToken);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> signUp({required String email, required String password}) async {
    try {
      final response = await _dio.post('/api/auth/signup', data: {
        'email': email,
        'password': password,
      });

      final data = response.data as Map<String, dynamic>;
      final accessToken = data['access_token'] as String?;
      final refreshToken = data['refresh_token'] as String?;

      if (accessToken != null && refreshToken != null) {
        await Supabase.instance.client.auth.setSession(accessToken, refreshToken);
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
  }
}
