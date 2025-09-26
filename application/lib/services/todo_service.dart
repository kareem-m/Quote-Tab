import 'package:quote_tab_todo/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class TodoService {

  static Future<List<dynamic>> getTodos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;

    final url = Uri.parse('https://quote-tab-backend.vercel.app/api/todos');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('failed : ${response.body}');
        return [];
      }
    } catch (e) {
      print('error : $e');
      return [];
    }
  }

  static Future<bool> setNewTodo(Task todo) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;

    final url = Uri.parse('https://quote-tab-backend.vercel.app/api/todos');

    final Map<String, dynamic> todoData = {
      '_id' : todo.id,
      'title': todo.title,
      'completed' : todo.completed
    };

    try {
      final response = await http.post(
      url,
      headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      body: jsonEncode(todoData)
    );
    print('Response body: ${response.body}');
    print('Response code: ${response.statusCode}');
    if(response.statusCode == 200 || response.statusCode == 201){
      return true;
    }
    else{
      return false;
    }
    
    } catch(e){
      print('connection error');
      return false;
    }
  }

  static Future<bool> deleteTodo(Task todo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;

    final url = Uri.parse('https://quote-tab-backend.vercel.app/api/todos?id=${todo.id}');

    try{
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Response body: ${response.body}');
      print('Response code: ${response.statusCode}');

      if(response.statusCode == 200){
        return true;
      }
      else {return false;}

    }
    catch(e){
      print('connection error');
      return false;
    }
}
  static Future<bool> changeCompleted(Task todo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;

    final url = Uri.parse('https://quote-tab-backend.vercel.app/api/todos?id=${todo.id}');

    final Map<String, bool> changeData = {
      'completed' : !todo.completed
    };

    try{
      final response = await http.put(url,
      headers: {'Content-Type': 'application/json',
      'Authorization' : 'Bearer $token'
      },
      body: jsonEncode(changeData)
      );
      print('Response: ${response.body}');
      print('Response Code: ${response.statusCode}');
      if(response.statusCode == 200 || response.statusCode == 201){
        return true;
      }
      else{
        return false;
      }
    }
    catch(e){
      print('failed to connect');
      return false;
    }

  }

}