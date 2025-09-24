import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:uuid/uuid.dart';


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

  static Future<bool> setNewTodo(String todo, {String? id}) async {
    final uuid = Uuid();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;

    final url = Uri.parse('https://quote-tab-backend.vercel.app/api/todos');

    final Map<String, dynamic> todoData = {
      '_id' : id ?? uuid.v1(),
      'title': todo,
      'completed' : false
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

  static Future<bool> deleteTodo(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;

    final url = Uri.parse('https://quote-tab-backend.vercel.app/api/todos?id=$id');

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
  static Future<bool> changeCompleted(String id, bool changeTo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;

    final url = Uri.parse('https://quote-tab-backend.vercel.app/api/todos?id=$id');

    final Map<String, bool> changeData = {
      'completed' : changeTo
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