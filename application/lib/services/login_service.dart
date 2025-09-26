import 'package:http/http.dart' as http;
import 'package:quote_tab_todo/models/user.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart'; // for json

class LoginService {
  final User user;
  late final http.Response finalResponse;

  LoginService({required this.user});

  Future<void> loginUser() async {
    final url = Uri.parse('https://quote-tab-backend.vercel.app/api/auth/login');

    final Map<String, String> userData = {
      'username': user.username,
      'password': user.password,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      finalResponse = response;
      print('Response Code: ${finalResponse.statusCode}');
      print('Responce body: ${finalResponse.body}');
    } catch (e) {
      print('خطأ في الاتصال');
    }
  }

  //login = true and save user
  Future<void> setLoginOnStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setStringList('currentUser', [user.username, user.password]);
    prefs.setString('token', jsonDecode(finalResponse.body)['token']);
  }

  //login = false and clear current user
  static Future<void> setLogoutOnStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.setStringList('currentUser', ['', '']);
    prefs.setString('token', '');
  }

}
