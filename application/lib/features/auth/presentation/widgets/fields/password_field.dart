import 'package:clean_quote_tab_todo/features/auth/presentation/providers/form_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordField extends ConsumerWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;

    String? passwordValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your Password';
      }
      return null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),

      child: Container(
        width: size.width - 50,
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(25),
        ),

        //field
        child: TextFormField(
          keyboardType: TextInputType.visiblePassword,
          controller: ref.watch(passwordControllerProvider),
          obscureText: ref.watch(isObscureNotifierProvider),
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
            suffixIcon: IconButton(
              onPressed: () =>
                  ref.read(isObscureNotifierProvider.notifier).change(),
              icon: Icon(
                ref.watch(isObscureNotifierProvider)
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.white,
              ),
            ),
          ),
          validator: passwordValidator,
        ),
      ),
    );
  }
}
