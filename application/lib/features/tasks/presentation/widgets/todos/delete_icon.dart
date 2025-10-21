import 'package:clean_quote_tab_todo/features/tasks/domain/entities/task_entity.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/providers/tasks_notifier_provider.dart';
import 'package:clean_quote_tab_todo/core/common/ui/snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteIcon extends ConsumerWidget {
  final TaskEntity todo;

  const DeleteIcon({super.key, required this.todo});

  @override
  Widget build(BuildContext context, ref) {
    final todoNotifier = ref.read(todoListNotifierProvider.notifier);

    return IconButton(
      onPressed: () async {
        final error = await todoNotifier.deleteTodo(todo);
        if (!(error == null) && context.mounted) {
          showSnackIfError(context, error);
        }
      },
      icon: const Icon(Icons.close, fontWeight: FontWeight.bold),
    );
  }
}
