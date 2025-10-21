import 'package:clean_quote_tab_todo/features/tasks/domain/entities/task_entity.dart';
import 'package:clean_quote_tab_todo/features/tasks/domain/repo/tasks_repository.dart';

class ChangeCompleted {
  final TasksRepository repo;

  ChangeCompleted(this.repo);

  Future<void> call (TaskEntity todo) async {
    await repo.changeCompleted(todo);
  }
}