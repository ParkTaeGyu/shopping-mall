import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final apiBaseUrlProvider = Provider<String>((ref) {
  return dotenv.env['API_URL'] ?? 'http://localhost:8080';
});

final dioProvider = Provider<Dio>((ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  final dio = Dio(BaseOptions(baseUrl: baseUrl));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = Supabase.instance.client.auth.currentSession?.accessToken;
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      options.headers['Content-Type'] = 'application/json';
      handler.next(options);
    },
  ));

  return dio;
});
