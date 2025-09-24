import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart'; // for json

class LoginService {
  final String usernameLogin;
  final String passwordLogin;
  late final http.Response finalResponse;

  LoginService({required this.usernameLogin, required this.passwordLogin});

  Future<void> loginUser() async {
    final url = Uri.parse('https://quote-tab-backend.vercel.app/api/auth/login');

    final Map<String, String> userData = {
      'username': usernameLogin,
      'password': passwordLogin,
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
  Future<void> setLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setStringList('currentUser', [usernameLogin, passwordLogin]);
    prefs.setString('token', jsonDecode(finalResponse.body)['token']);
  }

  //login = false and clear current user
  static Future<void> setLogout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.setStringList('currentUser', ['', '']);
  }

}
