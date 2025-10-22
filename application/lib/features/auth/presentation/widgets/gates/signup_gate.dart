import 'package:clean_quote_tab_todo/core/router/app_router.dart';
import 'package:flutter/material.dart';

class SignupGate extends StatelessWidget {
  final router = AppRouter();
  SignupGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Don\'t have an account yet? '),
        TextButton(
          onPressed: () {
            router.navigateToSignup(context);
          },
          child: Text(
            'Sign Up here!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
