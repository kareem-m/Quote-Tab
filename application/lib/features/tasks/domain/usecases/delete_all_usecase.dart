import 'package:clean_quote_tab_todo/features/tasks/domain/entities/task_entity.dart';
import 'package:clean_quote_tab_todo/features/tasks/domain/repo/tasks_repository.dart';

class DeleteAllUsecase {
  final TasksRepository repo;

  DeleteAllUsecase(this.repo);

  Future<void> call (List<TaskEntity> todos) async {
    await repo.deleteAllTodos(todos);
  }
}