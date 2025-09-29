import 'dart:convert';

import 'package:http/http.dart' as http;

class VersionService {
  static Future<String> androidVersion () async {
    final url = Uri.parse('https://quote-tab.netlify.app/update-info.json');

    try{
      final response = await http.get(url);

      print('Response: ${response.body}');
      print('Response Code: ${response.statusCode}');

      if (response.statusCode == 200){
        final data = jsonDecode(response.body);
        return data['android_version'];
      }
      else{
        print("failed request");
        return "error";
      }
    }
    catch(e){
      print('Error Connection');
      return "error";
    }
  }
}