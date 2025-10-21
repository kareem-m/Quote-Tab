import 'package:clean_quote_tab_todo/features/tasks/presentation/providers/tasks_notifier_provider.dart';
import 'package:clean_quote_tab_todo/core/common/ui/snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RefreshIcon extends ConsumerWidget {
  const RefreshIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifierProvider = ref.read(todoListNotifierProvider.notifier);
    return IconButton(
      onPressed: () async {
        final error = await notifierProvider.refreshTodos();
        showSnackIfError(context, error);
      },
      icon: const Icon(Icons.refresh, color: Colors.white),
    );
  }
}