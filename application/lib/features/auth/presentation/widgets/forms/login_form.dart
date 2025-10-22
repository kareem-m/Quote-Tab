import 'package:clean_quote_tab_todo/features/auth/presentation/providers/form_providers.dart';
import 'package:clean_quote_tab_todo/features/auth/presentation/widgets/fields/password_field.dart';
import 'package:clean_quote_tab_todo/features/auth/presentation/widgets/fields/username_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, ref) {
        return Form(
      key: ref.watch(formKeyProvider),
      child: Column(
        children: [UsernameField(),
        PasswordField(),
        ]
      ));
  }
}