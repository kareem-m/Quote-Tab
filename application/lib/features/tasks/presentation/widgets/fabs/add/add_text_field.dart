import 'package:clean_quote_tab_todo/core/common/ui/snack.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/providers/tasks_notifier_provider.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/providers/text_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTextField extends ConsumerWidget {
  const AddTextField({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return TextField(
      focusNode: ref.watch(textFocusNodeProvider),
      controller: ref.watch(textControllerProvider),
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(border: InputBorder.none),
      onSubmitted: (value) async {
        Navigator.pop(context);
        ref.read(textControllerProvider).clear();
        final error = await ref.read(todoListNotifierProvider.notifier).addTodo(value);
        showSnackIfError(context, error);
      },
    );
  }
}