import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/app_user.dart';

class AuthController extends StateNotifier<AppUser?> {
  AuthController() : super(null);

  Future<bool> login({required String email, required String password}) async {
    // Hardcoded credentials for demo
    if (email == 'admin' && password == '1111') {
      state = const AppUser(uid: 'admin_uid', email: 'admin', role: UserRole.admin);
      return true;
    }

    if (email == 'test1' && password == '1111') {
      state = const AppUser(uid: 'user_uid', email: 'test1', role: UserRole.user);
      return true;
    }

    return false;
  }

  void logout() {
    state = null;
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AppUser?>((ref) {
  return AuthController();
});
