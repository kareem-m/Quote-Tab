import 'package:clean_quote_tab_todo/features/tasks/data/datasources/api_data_source.dart';
import 'package:clean_quote_tab_todo/features/tasks/data/datasources/local_data_source.dart';
import 'package:clean_quote_tab_todo/features/tasks/data/models/task_model.dart';
import 'package:clean_quote_tab_todo/features/tasks/domain/entities/task_entity.dart';
import 'package:clean_quote_tab_todo/features/tasks/domain/repo/tasks_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskRepoImpl implements TasksRepository {
  final LocalDataSource localSource;
  final ApiDataSource apiSource;
  final SharedPreferences prefs;

  TaskRepoImpl({required this.localSource, required this.apiSource, required this.prefs});

  @override
  Future<void> changeCompleted(TaskEntity todo) async {
    final taskModelToModify = TaskModel.fromEntity(todo);
    await apiSource.changeCompleted(taskModelToModify);
  }

  @override
  Future<void> deleteTodo(TaskEntity todo) async {
    final taskModelToDelete = TaskModel.fromEntity(todo);
    await apiSource.deleteTodo(taskModelToDelete);
  }

  @override
  Future<void> deleteAllTodos(List<TaskEntity> todos) async {
    final taskModelList = todos
        .map((entity) => TaskModel.fromEntity(entity))
        .toList();
    for (TaskModel task in taskModelList) {
      try {
        await apiSource.deleteTodo(task);
      } catch (e) {
        throw Exception('Failed to delete all Todos, Please Try again.');
      }
    }
  }

  @override
  Future<List<TaskEntity>> loadTodos() async {
    if (!(prefs.getBool('usedOnce') ?? false)) {
      final todosFromApi = await getTodosFromApi();
      localSource.cacheTodos(todosFromApi.map((entity) => TaskModel.fromEntity(entity)).toList());
      prefs.setBool('usedOnce', true);
      return todosFromApi;
    } else {
      final models = localSource.getTodos();
      return models.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<List<TaskEntity>> getTodosFromApi() async {
    final models = await apiSource.getTodos();
    final entities = models.map((model){
      model = model as TaskModel;
      return model.toEntity();
    }).toList();
    return entities;
  }

  @override
  Future<void> setNewTodo(TaskEntity todo) async {
    await apiSource.setNewTodo(TaskModel.fromEntity(todo));
  }

  @override
  Future<void> cacheTodos(List<TaskEntity> todos) async {
    final models = todos.map((todo) => TaskModel.fromEntity(todo)).toList();

    localSource.cacheTodos(models);
  }
}