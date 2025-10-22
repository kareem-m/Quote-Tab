import 'package:clean_quote_tab_todo/core/errors/failure.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/providers/tasks_notifier_provider.dart';
import 'package:clean_quote_tab_todo/core/common/ui/loading_widget.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/widgets/todos/task_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodosList extends ConsumerWidget {
  const TodosList({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final todosNotifier = ref.watch(todoListNotifierProvider);

    return todosNotifier.when(
      data: (data) => ListView.builder(
        itemBuilder: (context, index) => TaskItem(todo: data[index]),
        itemCount: data.length,
      ),
      error: (error, stackTrace) {
        return Center(
          child: Text(
            error is Failure ? error.message : error.toString(),
            style: TextStyle(color: Colors.red, fontSize: 28),
          ),
        );
      },
      loading: () => LoadingWidget(),
    );
  }
}
