import 'package:clean_quote_tab_todo/core/router/app_router.dart';
import 'package:clean_quote_tab_todo/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogoutIcon extends ConsumerWidget {
  final router = AppRouter();
  LogoutIcon({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return IconButton(
      onPressed: () {
        ref.read(logoutProvider).call();
        router.navigateToLogin(context);
      },
      icon: const Icon(Icons.logout, color: Colors.white),
    );
  }
}