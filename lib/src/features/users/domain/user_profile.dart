import '../../auth/domain/app_user.dart';

class UserProfile {
  final String id;
  final String email;
  final UserRole role;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'] ?? '',
      role: UserRole.values.firstWhere((e) => e.name == json['role'], orElse: () => UserRole.user),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
