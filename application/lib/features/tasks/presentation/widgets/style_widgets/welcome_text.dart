import 'package:clean_quote_tab_todo/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WelcomeText extends ConsumerWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final authProvider = ref.watch(authNotifierProvider);
    final username = authProvider.value?.username ?? 'unknown';
    return SizedBox(
      height: 50,
      child: Center(
        child: Text('Welcome, $username', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}