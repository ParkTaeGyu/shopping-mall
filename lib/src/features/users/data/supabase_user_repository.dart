import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/domain/app_user.dart';
import '../domain/user_profile.dart';

class SupabaseUserRepository {
  final SupabaseClient _client;

  SupabaseUserRepository(this._client);

  Future<List<UserProfile>> getProfiles() async {
    final response = await _client.from('profiles').select().order('created_at', ascending: false);
    final data = response as List<dynamic>;
    return data.map((json) => UserProfile.fromJson(json)).toList();
  }

  Future<void> updateUserRole(String userId, UserRole role) async {
    await _client.from('profiles').update({'role': role.name}).eq('id', userId);
  }
}

final supabaseUserRepositoryProvider = Provider<SupabaseUserRepository>((ref) {
  return SupabaseUserRepository(Supabase.instance.client);
});

final adminUsersProvider = FutureProvider<List<UserProfile>>((ref) {
  return ref.watch(supabaseUserRepositoryProvider).getProfiles();
});
