import 'dart:convert';
import 'dart:developer';

import 'package:clean_quote_tab_todo/core/api/apis.dart';
import 'package:clean_quote_tab_todo/core/errors/failure.dart';
import 'package:clean_quote_tab_todo/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class ApiDataSource {
  Future<UserModel> loginUser(String username, String password) async {
    final url = Uri.parse(loginApi);

    final Map<String, String> userData = {
      'username': username,
      'password': password,
    };

    late final http.Response response;

    try {
      response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );}
      catch(e){
        log('connection error');
        throw ConnectionFailure('Failed to Connect to the Server, Please try again!');
      }

      log('Response Code: ${response.statusCode}');
      log('Responce body: ${response.body}');

      final json = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return UserModel.fromJson(json);
      } else {
        throw ServerFailure(json['message']);
      }
  }
  Future<UserModel> registerUser(String username, String password) async {
    final url = Uri.parse(signupApi);

    final Map<String, String> userData = {
      'username': username,
      'password': password,
    };

    late final http.Response response;

    try{
      response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );}
      catch(e){
        throw ConnectionFailure('Failed to Connect to the Server, Please try again!');
      }

      log('Response code ${response.statusCode}');
      log("Response body: ${jsonDecode(response.body)}");

      final json = jsonDecode(response.body);

      if(response.statusCode == 201){
        return UserModel.fromJson(json);
      } else{
        throw ServerFailure(json['message']);
      }
    }
}