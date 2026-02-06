import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/domain/app_user.dart';
import '../../users/domain/user_profile.dart'; // Alias not needed yet
import '../../users/data/supabase_user_repository.dart';

class AdminUserListScreen extends ConsumerWidget {
  const AdminUserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(adminUsersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: usersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return const Center(child: Text('No users found'));
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(user.role == UserRole.admin ? 'A' : 'U'),
                  ),
                  title: Text(user.email),
                  subtitle: Text('ID: ${user.id}'),
                  trailing: DropdownButton<UserRole>(
                    value: user.role,
                    onChanged: (newRole) async {
                      if (newRole != null && newRole != user.role) {
                         bool confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Change Role'),
                            content: Text("Change ${user.email}'s role to ${newRole.label}?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Confirm'),
                              ),
                            ],
                          ),
                        ) ?? false;

                        if (confirm) {
                          await ref.read(supabaseUserRepositoryProvider).updateUserRole(user.id, newRole);
                          ref.invalidate(adminUsersProvider);
                        }
                      }
                    },
                    items: UserRole.values.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role.label),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
