enum UserRole {
  admin,
  user;

  String get label => name.toUpperCase();
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
