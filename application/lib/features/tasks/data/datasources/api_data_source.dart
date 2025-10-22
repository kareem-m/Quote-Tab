import 'dart:convert';
import 'dart:developer';
import 'package:clean_quote_tab_todo/core/api/apis.dart';
import 'package:clean_quote_tab_todo/core/errors/failure.dart';
import 'package:clean_quote_tab_todo/features/tasks/data/models/task_model.dart';
import 'package:http/http.dart' as http;

class ApiDataSource {
  final String token;

  ApiDataSource(this.token);

  Future<List<dynamic>> getTodos() async {
    final url = Uri.parse(todosApi);

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> tasksList = jsonDecode(response.body)
            .map(
              (task) => TaskModel.fromJson(task),
            )
            .toList();
        return tasksList;
      } else {
        log('failed : ${response.body}');
        throw ServerFailure('Failed to fetch todos');
      }
    } catch (e) {
      log('error : $e');
      throw ConnectionFailure('Failed To Connect to the server, Please try again later.');
    }
  }

  Future<void> setNewTodo(TaskModel todo) async {
    final url = Uri.parse(todosApi);

    final Map<String, dynamic> todoData = {
      '_id': todo.id,
      'title': todo.title,
      'completed': todo.completed,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(todoData),
      );
      log('Response body: ${response.body}');
      log('Response code: ${response.statusCode}');
      if (!(response.statusCode == 200 || response.statusCode == 201)) {
        throw ServerFailure('Failed to add a task, please try again later');
      }
    } catch (e) {
      log('error: $e');
      throw ConnectionFailure('Failed To Connect to the server, Please try again later.');
    }
  }

  Future<void> deleteTodo(TaskModel todo) async {
    final url = Uri.parse(
      '$todosApi?id=${todo.id}',
    );

    try {
      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      log('Response body: ${response.body}');
      log('Response code: ${response.statusCode}');

      if (!(response.statusCode == 200)) {
        throw ServerFailure('Failed to delete the task.');
      }
    } catch (e) {
      log('connection error');
      throw ConnectionFailure('Failed To Connect to the server, Please try again later.');
    }
  }

  Future<void> changeCompleted(TaskModel todo) async {
    final url = Uri.parse(
      '$todosApi?id=${todo.id}',
    );

    final Map<String, bool> changeData = {'completed': !todo.completed};

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(changeData),
      );
      log('Response: ${response.body}');
      log('Response Code: ${response.statusCode}');
      if (!(response.statusCode == 200 || response.statusCode == 201)) {
        throw ServerFailure('Failed to Change The State.');
      }
    } catch (e) {
      log('failed to connect');
      throw ConnectionFailure('Failed To Connect to the server, Please try again later.');
    }
  }
}
