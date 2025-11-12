import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/service_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('👤 Profile')),
      body: currentUser.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Please log in to view profile.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage:
                      user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                  child: user.photoUrl == null
                      ? Text(
                          user.name.isNotEmpty ? user.name[0] : 'U',
                          style: Theme.of(context).textTheme.headlineMedium,
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                if (user.bio != null && user.bio!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    user.bio!,
                    textAlign: TextAlign.center,
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatCard(label: 'Followers', value: '${user.followersCount}'),
                    _StatCard(label: 'Following', value: '${user.followingCount}'),
                    _StatCard(label: 'Coins', value: '${user.coins}'),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(Routes.editProfile);
                    },
                    child: const Text('Edit Profile'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () async {
                      final authService = ref.read(authServiceProvider);
                      await authService.logout();
                      if (context.mounted) {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil(Routes.login, (route) => false);
                      }
                    },
                    child: const Text('Logout'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }
}


