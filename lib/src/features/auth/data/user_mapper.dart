import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/app_user.dart';

extension UserMapper on User {
  AppUser toAppUser() {
    // Determine role from metadata or fallback to user
    final roleStr = userMetadata?['role'] as String?;
    final role = roleStr == 'admin' ? UserRole.admin : UserRole.user;
    
    return AppUser(
      uid: id,
      email: email ?? '',
      role: role,
    );
  }
}
