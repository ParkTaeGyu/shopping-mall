import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 정보')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ref.read(authControllerProvider.notifier).logout();
          },
          child: const Text('로그아웃'),
        ),
      ),
    );
  }
}
