import 'package:clean_quote_tab_todo/core/common/ui/snack.dart';
import 'package:clean_quote_tab_todo/core/constants/const_colors.dart';
import 'package:clean_quote_tab_todo/core/errors/failure.dart';
import 'package:clean_quote_tab_todo/core/router/app_router.dart';
import 'package:clean_quote_tab_todo/features/auth/presentation/providers/auth_providers.dart';
import 'package:clean_quote_tab_todo/features/auth/presentation/providers/form_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginButton extends ConsumerWidget {
  final router = AppRouter();
  LoginButton({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;

    ref.listen(authNotifierProvider, (oldState, newState) {
      newState.when(
        data: (data) {
          if (data != null && (oldState?.isLoading ?? false)) {
            router.navigateToHome(context, data.username);
          }
        },
        error: (error, trace) {
          showSnackIfError(context, error is Failure ? error.message : error.toString());
        },
        loading: () {},
      );
    });

    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () async {
              final username = ref.watch(usernameControllerProvider).text;
              final password = ref.watch(passwordControllerProvider).text;

              if (ref.read(formKeyProvider).currentState!.validate()) {
                ref
                    .read(authNotifierProvider.notifier)
                    .login(username, password);
              }
            },
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(secondAppColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
      ),
    );
  }
}
