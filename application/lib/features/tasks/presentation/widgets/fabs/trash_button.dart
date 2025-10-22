import 'package:clean_quote_tab_todo/core/constants/constants.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/providers/tasks_notifier_provider.dart';
import 'package:clean_quote_tab_todo/core/common/ui/snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrashButton extends ConsumerWidget {
  const TrashButton({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final todoNotifier = ref.read(todoListNotifierProvider.notifier);
    return FloatingActionButton(
      heroTag: 'todo-fab',
      backgroundColor: trashButtonColor,
      onPressed: () async {
        final error = await todoNotifier.deleteAll();
        showSnackIfError(context, error);
      },
      child: Icon(Icons.delete),
    );
  }
}