import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../core/api_client.dart';
import '../../auth/domain/app_user.dart';
import '../domain/user_profile.dart';

class SupabaseUserRepository {
  final Dio _dio;

  SupabaseUserRepository(this._dio);

  Future<List<UserProfile>> getProfiles() async {
    final response = await _dio.get('/api/admin/users');
    final data = response.data as List<dynamic>;
    return data.map((json) => UserProfile.fromJson(json)).toList();
  }

  Future<void> updateUserRole(String userId, UserRole role) async {
    await _dio.put('/api/admin/users/$userId/role', data: {
      'role': role.name,
    });
  }
}

final supabaseUserRepositoryProvider = Provider<SupabaseUserRepository>((ref) {
  return SupabaseUserRepository(ref.watch(dioProvider));
});

final adminUsersProvider = FutureProvider<List<UserProfile>>((ref) {
  return ref.watch(supabaseUserRepositoryProvider).getProfiles();
});
