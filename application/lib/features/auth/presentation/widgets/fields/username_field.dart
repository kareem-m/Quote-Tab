import 'package:clean_quote_tab_todo/features/auth/presentation/providers/form_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UsernameField extends ConsumerWidget {
  const UsernameField({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final size = MediaQuery.of(context).size;

    String? usernameValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your username';
      }
      final trimmedValue = value.trim();

      if (trimmedValue.contains(' ')) {
        return 'Username cannot contain spaces';
      }

      if (!(RegExp(r'^[a-zA-Z0-9_.-]+$').hasMatch(trimmedValue))) {
        return 'Use Valid username';
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
          keyboardType: TextInputType.text,
          controller: ref.watch(usernameControllerProvider),
          decoration: InputDecoration(
            labelText: 'Username',
            labelStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          validator: usernameValidator
        ),
      ),
    );
  }
}
