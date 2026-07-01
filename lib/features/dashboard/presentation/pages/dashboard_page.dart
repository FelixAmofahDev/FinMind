import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authProvider).asData?.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          TextButton(
            onPressed: () => ref.read(authProvider.notifier).signOut(),
            child: const Text('Sign out'),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Welcome ${session?.user.fullName ?? 'User'}\n\n'
            'Your account is verified and onboarding is complete.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}