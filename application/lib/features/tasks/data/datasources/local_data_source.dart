import 'package:clean_quote_tab_todo/features/tasks/data/models/task_model.dart';
import 'package:hive/hive.dart';

class LocalDataSource {
  final Box<TaskModel> _tasksBox;

  LocalDataSource(this._tasksBox);

  List<TaskModel> getTodos() => _tasksBox.values.toList();

  Future<void> cacheTodos(List<TaskModel> todos) async {
     _tasksBox.clear();
     _tasksBox.addAll(todos);
  }
}