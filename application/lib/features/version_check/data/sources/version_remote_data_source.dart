import 'dart:convert';
import 'dart:developer';

import 'package:clean_quote_tab_todo/core/errors/failure.dart';
import 'package:http/http.dart' as http;

class VersionRemoteDataSource {
  final _url = Uri.parse('https://quote-tab.netlify.app/update-info.json');

  Future<String> getLatestAndroidVersion() async {
    try{
      final response = await http.get(_url);
      log(response.statusCode.toString());
      log(response.body);

      if (response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data['android_version'];
      }
      else {
        throw ServerFailure('Failed to get Latest version');
      }
    }catch (e){
      throw ConnectionFailure('Failed to connect to the server, Please try again!');
    }
  }
 }