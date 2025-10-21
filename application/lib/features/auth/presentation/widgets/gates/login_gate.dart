import 'package:clean_quote_tab_todo/core/router/app_router.dart';
import 'package:flutter/material.dart';

class LoginGate extends StatelessWidget {
  final router = AppRouter();
  LoginGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account? '),
        TextButton(
          onPressed: () {
            router.navigateToLogin(context);
          },
          child: const Text(
            'Log in here!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
