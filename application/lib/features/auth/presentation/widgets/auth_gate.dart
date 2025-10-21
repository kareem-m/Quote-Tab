import 'package:clean_quote_tab_todo/core/common/ui/loading_widget.dart';
import 'package:clean_quote_tab_todo/core/constants/const_colors.dart';
import 'package:clean_quote_tab_todo/features/auth/presentation/providers/auth_providers.dart';
import 'package:clean_quote_tab_todo/features/auth/presentation/screens/login_screen.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final authState = ref.watch(authNotifierProvider);

    return authState.when(
      data: (currentUser) {
        if (currentUser == null) {
          return const LoginScreen();
        } else {
          return HomeScreen();
        }
      },
      error: (error, trace) {
        return Scaffold(
          backgroundColor: mainAppColor, //
          body: Center(
            child: Text(
              'Something went wrong: $error',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
        );
      },
      loading: () => LoadingWidget(),
    );
  }
}
