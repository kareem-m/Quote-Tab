import 'package:clean_quote_tab_todo/features/tasks/domain/entities/task_entity.dart';

abstract class TasksRepository {
  Future<List<TaskEntity>> loadTodos();
  Future<List<TaskEntity>> getTodosFromApi();
  Future<void> cacheTodos(List<TaskEntity> todos);
  Future<void> setNewTodo(TaskEntity todo);
  Future<void> deleteTodo(TaskEntity todo);
  Future<void> deleteAllTodos(List<TaskEntity> todos);
  Future<void> changeCompleted(TaskEntity todo);
}
