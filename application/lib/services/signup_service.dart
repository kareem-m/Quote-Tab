import 'package:http/http.dart' as http;
import 'package:quote_tab_todo/models/user.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart'; // for json

class SignupService {
  // final String usernameRegister;
  // final String passwordRegister;
  final User user;
  late final http.Response finalResponse;

  SignupService({
    required this.user
  });

  Future<void> registerUser() async {
    final url = Uri.parse(
      'https://quote-tab-backend.vercel.app/api/auth/register',
    );

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
      //بجرب هنا اشوف النتايج في ال console
      print('Response code ${finalResponse.statusCode}');
      print("Response body: ${jsonDecode(finalResponse.body)}");
    } catch (e) {
      print('خطأ في الاتصال');
    }
  }
  Future<void> setLoginOnStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setStringList('currentUser', [user.username, user.password]);
    prefs.setString('token', jsonDecode(finalResponse.body)['token']);
  }
}
