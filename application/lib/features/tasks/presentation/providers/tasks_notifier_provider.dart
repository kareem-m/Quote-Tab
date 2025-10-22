import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:clean_quote_tab_todo/core/errors/failure.dart';
import 'package:clean_quote_tab_todo/features/tasks/domain/entities/task_entity.dart';
import 'package:clean_quote_tab_todo/features/tasks/presentation/providers/tasks_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final todoListNotifierProvider =
    AsyncNotifierProvider<TodoListNotifier, List<TaskEntity>>(() {
      return TodoListNotifier();
    });

class TodoListNotifier extends AsyncNotifier<List<TaskEntity>> {
  @override
  Future<List<TaskEntity>> build() {
    return ref.watch(getTodosProvider).call();
  }

  Future<String?> addTodo(String todoTitle) async {
    final lastState = state;
    final currentTodos = state.value!;

    final newTodo = TaskEntity(
      id: ref.read(uuidProvider).v4(),
      title: todoTitle,
      completed: false,
    );

    int firstCompletedIndex = currentTodos.indexWhere(
      (task) => task.completed == true,
    );

    if (firstCompletedIndex == -1) {
      state = AsyncValue.data([...currentTodos, newTodo]);
    } else {
      final List<TaskEntity> newList = List.from(currentTodos);
      newList.insert(firstCompletedIndex, newTodo);
      state = AsyncValue.data(newList);
    }

    try {
      await ref.read(addTodoProvider).call(newTodo);
      await ref.read(tasksRepoProvider).cacheTodos(state.value!);
      return null;
    } catch (e) {
      state = lastState;
      if(e is Failure){
        log(e.message);
        return e.message;
      }
      else{
        throw Exception(e);
      }
    }
  }

  Future<String?> changeCompleted(TaskEntity todo) async {
    final lastState = state;
    final currentTodos = state.value!;

    final updatedTasks = currentTodos.map((lastTodo) {
      if (todo == lastTodo) {
        return TaskEntity.changeCompleted(todo);
      } else {
        return lastTodo;
      }
    }).toList();
    updatedTasks.sort((a, b) => a.completed.toString().compareTo(b.completed.toString()));
    state = AsyncValue.data(updatedTasks);
    await ref
        .read(audioPlayerProvider)
        .play(
          AssetSource('audio/done.mp3'),
          volume: 0.2,
          //عشان اخلي الصوت يشتعل حتى وفي اغنية شغالة مثلا
          ctx: AudioContext(
            android: AudioContextAndroid(
              contentType: AndroidContentType.sonification,
              audioFocus: AndroidAudioFocus.gainTransientMayDuck,
            ),
          ),
        );

    try {
      await ref.read(changeCompletedProvider).call(todo);
      await ref.read(tasksRepoProvider).cacheTodos(state.value!);
      return null;
    } catch (e) {
      state = lastState;
      if(e is Failure){
        log(e.message);
        return e.message;
      }
      else{
        throw Exception(e);
      }
    }
  }

  Future<String?> deleteAll() async {
    final lastState = state;
    final currentTodos = state.value!;

    state = AsyncValue.data([]);

    try {
      await ref.read(deleteAllTodosProvider).call(currentTodos);
      await ref.read(tasksRepoProvider).cacheTodos(state.value!);
      return null;
    } catch (e) {
      state = lastState;
      log('$e');
      return e.toString();
    }
  }

  Future<String?> deleteTodo(TaskEntity todo) async {
    final lastState = state;
    final currentTodos = state.value!;

    final updatedList = currentTodos.where((task) => task != todo).toList();

    state = AsyncValue.data(updatedList);

    try {
      await ref.read(deleteTodoProvider).call(todo);
      await ref.read(tasksRepoProvider).cacheTodos(state.value!);
      return null;
    } catch (e) {
      state = lastState;
      if(e is Failure){
        log(e.message);
        return e.message;
      }
      else{
        throw Exception(e);
      }
    }
  }

  //
  Future<String?> refreshTodos() async {
    final lastState = state;

    try {
      state = AsyncValue.loading();
      final newList = await ref.read(refreshTodosFromApiProvider).call();
      state = AsyncValue.data(newList);
      await ref.read(tasksRepoProvider).cacheTodos(state.value!);
      return null;
    } catch (e) {
      state = lastState;
      if(e is Failure){
        log(e.message);
        return e.message;
      }
      else{
        throw Exception(e);
      }
    }
  }
}
