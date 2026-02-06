enum UserRole {
  admin,
  user,
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
