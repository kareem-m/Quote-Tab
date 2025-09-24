import 'package:http/http.dart' as http;
import 'dart:convert'; // for json

class SignupService {
  final String usernameRegister;
  final String passwordRegister;
  late final http.Response finalResponse;

  SignupService({
    required this.usernameRegister,
    required this.passwordRegister,
  });

  Future<void> registerUser() async {
    final url = Uri.parse(
      'https://quote-tab-backend.vercel.app/api/auth/register',
    );

    final Map<String, String> userData = {
      'username': usernameRegister,
      'password': passwordRegister,
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
}
