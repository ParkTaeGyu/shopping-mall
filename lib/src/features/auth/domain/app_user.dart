enum UserRole {
  admin,
  user;

  String get label {
    switch (this) {
      case UserRole.admin:
        return '관리자';
      case UserRole.user:
        return '일반';
    }
  }
}

class AppUser {
  final String uid;
  final String email;
  final UserRole role;

  const AppUser({
    required this.uid,
    required this.email,
    required this.role,
  });
}
