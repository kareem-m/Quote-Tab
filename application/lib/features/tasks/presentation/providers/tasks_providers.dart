import 'package:audioplayers/audioplayers.dart';
import 'package:clean_quote_tab_todo/core/common/providers/prefs_provider.dart';
import 'package:clean_quote_tab_todo/features/tasks/data/datasources/api_data_source.dart';
import 'package:clean_quote_tab_todo/features/tasks/data/datasources/local_data_source.dart';
import 'package:clean_quote_tab_todo/features/tasks/data/models/task_model.dart';
import 'package:clean_quote_tab_todo/features/tasks/data/repo/task_repo_impl.dart';
import 'package:clean_quote_tab_todo/features/tasks/domain/usecases/add_todo_usecase.dart';
import 'package:clean_quote_tab_todo/features/tasks/domain/usecases/change_completed.dart';
import 'package:clean_quote_tab_todo/features/tasks/domain/usecases/delete_all_usecase.dart';
import 'package:clean_quote_tab_todo/features/tasks/domain/usecases/delete_todo_usecase.dart';
import 'package:clean_quote_tab_todo/features/tasks/domain/usecases/get_todos_usecase.dart';
import 'package:clean_quote_tab_todo/features/tasks/domain/usecases/refresh_todos_from_api_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

//data sources providers
final localDSProvider = Provider.autoDispose((ref) {
  return LocalDataSource(Hive.box<TaskModel>('tasksBox'));
});

final apiDSProvider = Provider.autoDispose((ref) {
  final prefs = ref.watch(prefsProvider);
  final token = prefs.getString('token')!;
  return ApiDataSource(token);
});

final tasksRepoProvider = Provider.autoDispose((ref) {
  final local = ref.watch(localDSProvider);
  final api = ref.watch(apiDSProvider);
  final prefs = ref.watch(prefsProvider);

  return TaskRepoImpl(localSource: local, apiSource: api, prefs: prefs);
});

//usecases providers

final addTodoProvider = Provider.autoDispose((ref) {
  final repo = ref.watch(tasksRepoProvider);
  return AddTodoUsecase(repo);
});

final getTodosProvider = Provider.autoDispose((ref) {
  final repo = ref.watch(tasksRepoProvider);
  return GetTodosUsecase(repo);
});

final deleteAllTodosProvider = Provider.autoDispose((ref) {
  final repo = ref.watch(tasksRepoProvider);
  return DeleteAllUsecase(repo);
});

final deleteTodoProvider = Provider.autoDispose((ref) {
  final repo = ref.watch(tasksRepoProvider);
  return DeleteTodoUsecase(repo);
});

final refreshTodosFromApiProvider = Provider.autoDispose((ref) {
  final repo = ref.watch(tasksRepoProvider);
  return RefreshTodosFromApiUsecase(repo);
});

final changeCompletedProvider = Provider.autoDispose((ref) {
  final repo = ref.watch(tasksRepoProvider);
  return ChangeCompleted(repo);
});

//uuid provider

final uuidProvider = Provider.autoDispose<Uuid>((ref) => Uuid());

//sount effects provider

final audioPlayerProvider = Provider<AudioPlayer>((ref){
  final player = AudioPlayer();
  return player;
});