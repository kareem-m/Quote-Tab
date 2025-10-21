import 'package:clean_quote_tab_todo/features/tasks/domain/entities/task_entity.dart';
import 'package:clean_quote_tab_todo/features/tasks/domain/repo/tasks_repository.dart';

class RefreshTodosFromApiUsecase {
  final TasksRepository repo;

  const RefreshTodosFromApiUsecase(this.repo);

  Future<List<TaskEntity>> call() async {
    final entitiesList = await repo.getTodosFromApi();

    entitiesList.sort((a, b) => a.completed.toString().compareTo(b.completed.toString()));

    return entitiesList;
  }
}